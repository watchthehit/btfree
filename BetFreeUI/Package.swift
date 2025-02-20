// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "BetFreeUI",
    platforms: [
        .iOS(.v16),
        .macOS(.v13)
    ],
    products: [
        .library(
            name: "BetFreeUI",
            targets: ["BetFreeUI"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "BetFreeUI",
            dependencies: [],
            path: "Sources/BetFreeUI",
            resources: [
                .process("Resources")
            ]
        )
    ]
)
