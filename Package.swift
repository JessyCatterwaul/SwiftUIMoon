// swift-tools-version: 6.1

import PackageDescription

_ = Package(
  name: .libraryName,
  platforms: [.iOS(.v18), .macOS(.v15)],
  targets: [
    .target(name: .libraryName, path: "", resources: [.process("Moon.metal")])
  ],
)

extension String {
  static let libraryName = "Moon"
}
