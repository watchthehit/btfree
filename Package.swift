// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "BetFree",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "BetFree",
            targets: ["BetFree"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", exact: "1.7.0")
    ],
    targets: [
        .target(
            name: "BetFree",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ],
            path: "Sources/BetFree",
            resources: [
                .process("Design/Resources")
            ]
        ),
        .testTarget(
            name: "BetFreeTests",
            dependencies: ["BetFree"],
            path: "Tests/BetFreeTests"
        )
    ]
) 