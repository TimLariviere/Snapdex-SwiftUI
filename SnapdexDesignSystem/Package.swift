// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "SnapdexDesignSystem",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(
            name: "SnapdexDesignSystem",
            targets: ["SnapdexDesignSystem"]),
    ],
    targets: [
        .target(
            name: "SnapdexDesignSystem",
            resources: [
                .process("Resources/Colors.xcassets"),
                .process("Resources/Icons.xcassets")
            ]
        )
    ]
)
