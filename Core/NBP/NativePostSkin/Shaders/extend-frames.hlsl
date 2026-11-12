// Preserve native simulation frames and append two bone transform families.
// The native position CS consumes these as 80-byte structured records.
struct Frame { float4 row0; float4 row1; float4 row2; float4 row3; float4 data; };
struct Bone { float4 row0; float4 row1; float4 row2; float4 row3; };
StructuredBuffer<Frame> Simulation : register(t50);
StructuredBuffer<Bone> Bones : register(t51);
RWStructuredBuffer<Frame> Extended : register(u5);
cbuffer NativeParameters : register(b13) { uint4 Counts; float4 Blend; float4 Scale; };

[numthreads(64, 1, 1)]
void main(uint3 id : SV_DispatchThreadID)
{
    uint simulationCount, simulationStride, boneCount, boneStride;
    Simulation.GetDimensions(simulationCount, simulationStride);
    Bones.GetDimensions(boneCount, boneStride);
    uint index = id.x;
    if (index >= simulationCount + 2 * boneCount) return;
    Frame frame;
    if (index < simulationCount) {
        frame = Simulation[index];
        // Scale only affine output rows, keeping local depth conversion intact.
        frame.row0 *= Blend.w * Scale.x;
        frame.row1 *= Blend.w * Scale.x;
        frame.row2 *= Blend.w * Scale.x;
    } else {
        uint boneIndex = (index - simulationCount) % boneCount;
        Bone bone = Bones[boneIndex];
        // Skinning stores the affine transform by columns; mapped deformation
        // reads three rows for dp4. Transpose explicitly rather than relying on
        // HLSL's default matrix packing convention.
        float factor = index < simulationCount + boneCount ? 1.0 : Blend.w;
        frame.row0 = float4(bone.row0.x, bone.row1.x, bone.row2.x, bone.row3.x) * factor;
        frame.row1 = float4(bone.row0.y, bone.row1.y, bone.row2.y, bone.row3.y) * factor;
        frame.row2 = float4(bone.row0.z, bone.row1.z, bone.row2.z, bone.row3.z) * factor;
        frame.row3 = float4(0, 0, 0, 1);
        frame.data = float4(1, 1, 0, 0);
    }
    Extended[index] = frame;
}
