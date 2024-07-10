#include <metal_stdlib>
using namespace metal;

struct Moon {
  half light;
  half mask;

  Moon(float2 position, float frameSize, const float phase) {
    // Construct a hemisphere facing the viewer,
    // to represent the moon.
    half3 normal; {
      auto normalizedPosition = 2 * half2(position / frameSize) - 1;
      normal.xy = normalizedPosition * normalizedPosition;
      normal.z = 1 - (normal.x + normal.y);
      normal.xy *= sign(normalizedPosition);
    }

    // Rotate the sunlight direction around the moon.
    // This is of course not what happens in reality,
    // but it's the same lighting result, when viewed from Earth.
    half2 sunlightDirection; {
      // Negating phase matches viewing from Earth's northern hemisphere.
      // This feels more natural to me, but I've never even been to the southern one.
      // It warrants localizing.
      // The offset makes multiples of 0 "new moons", and of π, "full moons".
      auto transformedPhase = -(half(phase) + M_PI_H);
      half sunlightDirection_z;
      sunlightDirection.x = sincos(transformedPhase, sunlightDirection_z);
      sunlightDirection.y = sunlightDirection_z;
    }

    // Mask out everything outside the moon, to avoid aliased edges.
    mask = step(0, normal.z);

      // Use binary light/dark as an incredibly rough approximation of reality.
    light = step(0, dot(normal.xz, sunlightDirection)) * mask;
  }
};
