// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "BetFreeModels",
    platforms: [
        .iOS(.v16),
        .macOS(.v10_15)
    ],
    products: [
        .library(
            name: "BetFreeModels",
            targets: ["BetFreeModels"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "BetFreeModels",
            dependencies: [],
            path: "Sources/BetFreeModels"
        )
    ]
)
