// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "swift-placeholder",
    platforms: [
        .macOS(.v14), .iOS(.v16), .tvOS(.v16), .watchOS(.v9), .visionOS(.v1),
    ],
    products: [
        .library(name: "Placeholder", targets: ["Placeholder"]),
    ],
    targets: [
        .target(name: "Placeholder"),
        .testTarget(name: "PlaceholderTests", dependencies: ["Placeholder"]),
    ]
)
