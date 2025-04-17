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
    ],
    targets: [
        .target(
            name: "SnapdexUI",
            dependencies: [
                "SnapdexDesignSystem",
                "SnapdexDomain",
                "SnapdexUseCases"
            ]//,
            //resources: [
            //    .process("Resources")
            //]
        )
    ]
)
