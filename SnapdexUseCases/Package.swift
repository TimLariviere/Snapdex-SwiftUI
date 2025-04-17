// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "SnapdexUseCases",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(
            name: "SnapdexUseCases",
            targets: ["SnapdexUseCases"]),
    ],
    dependencies: [
        .package(path: "../SnapdexDomain")
    ],
    targets: [
        .target(
            name: "SnapdexUseCases",
            dependencies: [
                "SnapdexDomain"
            ]
        )
    ]
)
