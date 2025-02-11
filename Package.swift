// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "BetFree",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(
            name: "BetFree",
            targets: ["BetFree"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "BetFree",
            dependencies: [],
            path: "Sources/BetFree",
            resources: [
                .process("Resources")
            ]
        ),
        .testTarget(
            name: "BetFreeTests",
            dependencies: ["BetFree"]
        ),
    ]
) 