import SwiftUI

struct MoonView<Moon: View>: View {
  @Binding private var phase: Float
  private let shader: ShaderFunction
  private let moon: () -> Moon

  init(
    phase: Binding<Float>,
    shader: (ShaderLibrary) -> ShaderFunction,
    moon: @escaping () -> Moon
  ) {
    _phase = phase
    self.shader = shader(ShaderLibrary.bundle(.module))
    self.moon = moon
  }

  var body: some View {
    moon().visualEffect { [phase] content, proxy in
      content.colorEffect(
        shader(
          .float(proxy.size.width),
          .float(phase)
        )
      )
    }
  }
}

private struct Preview: View  {
  @State private var phase: Float = 0
  let shader: (ShaderLibrary) -> ShaderFunction

  var body: some View {
    VStack {
      Spacer()
      MoonView(phase: $phase, shader: shader) {
        Circle().fill(.yellow)
      }
      HStack {
        let fontSize: Double = 150
        MoonView(phase: $phase, shader: shader) {
          Text("🌕").font(.system(size: fontSize))
        }
        MoonView(phase: $phase, shader: shader) {
          Text("🌝").font(.system(size: fontSize))
        }
      }
      Slider(value: $phase, in: (-2 * .pi)...(2 * .pi))
      Spacer()
    }
    .padding()
    .background(Color.indigo)
  }
}

#Preview("Opaque") {
  Preview(shader: \.opaqueMoon)
}

#Preview("Transparent") {
  Preview(shader: \.transparentMoon)
}
