// Shaders.metal
using namespace metal;

struct Vertex {
    float2 position [[attribute(0)]];
};

vertex float4 vertexShader(uint vertexID [[vertex_id]],
                           const device Vertex *vertices [[buffer(0)]]) {
    return float4(vertices[vertexID].position, 0.0, 1.0);
}

fragment float4 fragmentShader() {
    return float4(1.0, 1.0, 1.0, 1.0);  // Blanc
}