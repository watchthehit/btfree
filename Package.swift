// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "BetFree",
    platforms: [
        .iOS(.v16)
    ],
    products: [
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
        .target(
            name: "BetFree",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                "BetFreeUI",
                "BetFreeModels"
            ],
            path: "Sources/BetFree"
        ),
        .target(
            name: "BetFreeUI",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ],
            path: "BetFreeUI/Sources/BetFreeUI"
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