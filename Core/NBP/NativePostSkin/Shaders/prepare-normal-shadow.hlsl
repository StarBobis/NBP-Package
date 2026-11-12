// Copy native 40-byte vertex records while scaling only position.
// The original normal CS then sees the original subdivision-area scale.
ByteAddressBuffer Input : register(t50);
RWByteAddressBuffer Shadow : register(u5);
cbuffer Limits : register(b13) { uint Count; uint3 Reserved; };
[numthreads(64, 1, 1)]
void main(uint3 id : SV_DispatchThreadID)
{
    if (id.x >= Count) return;
    uint address = id.x * 40;
    float3 position = asfloat(Input.Load3(address));
    Shadow.Store3(address, asuint(position * 2.0));
    Shadow.Store3(address + 12, Input.Load3(address + 12));
    Shadow.Store4(address + 24, Input.Load4(address + 24));
}
