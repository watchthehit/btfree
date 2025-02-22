// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "BetFree",
    defaultLocalization: "en",
    platforms: [
        .macOS(.v13),
        .iOS(.v16)
    ],
    products: [
        .executable(
            name: "BetFreeApp",
            targets: ["BetFreeApp"]
        ),
        .library(
            name: "BetFree",
            targets: ["BetFree"]
        ),
        .library(
            name: "BetFreeUI",
            targets: ["BetFreeUI"]
        ),
        .library(
            name: "BetFreeModels",
            targets: ["BetFreeModels"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", exact: "1.2.0")
    ],
    targets: [
        .executableTarget(
            name: "BetFreeApp",
            dependencies: [
                "BetFree",
                "BetFreeUI",
                "BetFreeModels",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ],
            path: "Sources/BetFreeApp",
            swiftSettings: [
                .define("DEBUG", .when(configuration: .debug))
            ]
        ),
        .target(
            name: "BetFree",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                "BetFreeUI",
                "BetFreeModels"
            ],
            path: "Sources/BetFree",
            resources: [
                .process("Resources")
            ]
        ),
        .target(
            name: "BetFreeUI",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ],
            path: "BetFreeUI/Sources/BetFreeUI",
            resources: [
                .process("Resources")
            ]
        ),
        .target(
            name: "BetFreeModels",
            path: "Sources/BetFreeModels"
        ),
        .testTarget(
            name: "BetFreeTests",
            dependencies: ["BetFree"],
            path: "Tests/BetFreeTests"
        )
    ]
)