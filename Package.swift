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
            targets: ["BetFree"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", exact: "1.7.0"),
        .package(url: "https://github.com/apple/swift-syntax", from: "509.0.0")
    ],
    targets: [
        .target(
            name: "BetFree",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                .product(name: "SwiftSyntax", package: "swift-syntax"),
                .product(name: "SwiftParser", package: "swift-syntax")
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