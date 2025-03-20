#include <metal_stdlib>
#include "Moon.metal"
using namespace metal;

[[stitchable]] half4 opaqueMoon(float2 position, half4 color, float frameSize, float phase) {
  auto moon = Moon(position, frameSize, phase);
  return half4(color.rgb * moon.light, color.a * moon.mask);
}

[[stitchable]] half4 transparentMoon(float2 position, half4 color, float frameSize, float phase) {
  return color * Moon(position, frameSize, phase).light;
}
