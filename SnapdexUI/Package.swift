// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "SnapdexUI",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(
            name: "SnapdexUI",
            targets: ["SnapdexUI"]),
    ],
    dependencies: [
        .package(path: "../SnapdexDesignSystem"),
        .package(path: "../SnapdexDomain"),
        .package(path: "../SnapdexUseCases"),
        .package(url: "https://github.com/tevelee/SwiftUI-Flow.git", .upToNextMajor(from: "3.0.2")),
        .package(url: "https://github.com/gonzalezreal/swift-markdown-ui.git", .upToNextMajor(from: "2.4.1"))
    ],
    targets: [
        .target(
            name: "SnapdexUI",
            dependencies: [
                "SnapdexDesignSystem",
                "SnapdexDomain",
                "SnapdexUseCases"
            ],
            resources: [
                .process("Resources/Pokemons"),
                .process("Resources/Images.xcassets"),
                .process("Resources/Colors.xcassets"),
            ]
        )
    ]
)
