// Commit only the native normal result; preserve main positions and tangents.
ByteAddressBuffer Shadow : register(t50);
RWByteAddressBuffer Output : register(u5);
cbuffer Limits : register(b13) { uint Count; uint3 Reserved; };
[numthreads(64, 1, 1)]
void main(uint3 id : SV_DispatchThreadID)
{
    if (id.x >= Count) return;
    uint address = id.x * 40 + 12;
    Output.Store3(address, Shadow.Load3(address));
}
