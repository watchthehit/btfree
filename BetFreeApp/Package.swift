// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "BetFreeApp",
    platforms: [
        .iOS(.v16)
    ],
    dependencies: [
        .package(name: "BetFree", path: "../")
    ],
    targets: [
        .executableTarget(
            name: "BetFreeApp",
            dependencies: ["BetFree"],
            path: "BetFreeApp",
            resources: [
                .process("Resources")
            ]
        )
    ]
) 