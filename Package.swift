// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AsciiEdit",
    platforms: [
        .macOS(.v10_15)
    ],
    products: [
        .executable(name: "asciiedit", targets: ["AsciiEdit"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "0.4.3"),
        .package(url: "https://github.com/kylef/PathKit", from: "1.0.0")
    ],
    targets: [
        .target(name: "AsciiEdit", dependencies: [
            .product(name: "ArgumentParser", package: "swift-argument-parser"),
            "PathKit"
        ]),
        .testTarget(name: "AsciiEditTests", dependencies: ["AsciiEdit"])
    ]
)
