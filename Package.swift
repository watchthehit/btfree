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
            type: .dynamic,
            targets: ["BetFree"]),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", exact: "1.8.2"),
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
                .copy("Core/Data/Resources/CoreData/BetFreeModel.xcdatamodeld")
            ]
        ),
        .testTarget(
            name: "BetFreeTests",
            dependencies: ["BetFree"],
            path: "Tests/BetFreeTests"
        )
    ]
) 