// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BetFree",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v16),
        .macOS(.v14)
    ],
    products: [
        .library(
            name: "BetFree",
            targets: ["BetFree"]),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", exact: "1.7.0"),
    ],
    targets: [
        .target(
            name: "BetFree",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ],
            path: "Sources/BetFree",
            resources: [
                .process("Resources"),
                .process("Core/Data/Resources/CoreData")
            ],
            swiftSettings: [
                .enableExperimentalFeature("StrictConcurrency")
            ]
        ),
        .testTarget(
            name: "BetFreeTests",
            dependencies: ["BetFree"],
            path: "Tests/BetFreeTests"
        )
    ]
) 