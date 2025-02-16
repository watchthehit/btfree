// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "BetFree",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v16),
        .macOS(.v13)
    ],
    products: [
        .library(
            name: "BetFree",
            type: .dynamic,
            targets: ["BetFree"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", exact: "1.2.0"),
        .package(path: "Sources/BetFreeUI"),
        .package(path: "Sources/BetFreeModels")
    ],
    targets: [
        .target(
            name: "BetFree",
            dependencies: [
                .product(
                    name: "ComposableArchitecture",
                    package: "swift-composable-architecture"
                ),
                "BetFreeUI",
                "BetFreeModels"
            ],
            path: "Sources/BetFree",
            exclude: [
                "Core/Data/BetFree.xcdatamodeld/BetFree.xcdatamodel/contents"
            ],
            resources: [
                .process("Resources"),
                .process("Core/Data/BetFree.xcdatamodeld")
            ]
        ),
        .testTarget(
            name: "BetFreeTests",
            dependencies: ["BetFree"],
            path: "Tests/BetFreeTests"
        )
    ]
)