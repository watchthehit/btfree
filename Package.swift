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
            swiftSettings: [
                .enableUpcomingFeature("BareSlashRegexLiterals")
            ]
        )
    ]
) 