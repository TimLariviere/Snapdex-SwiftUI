// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "SnapdexDomain",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(
            name: "SnapdexDomain",
            targets: ["SnapdexDomain"]),
    ],
    targets: [
        .target(
            name: "SnapdexDomain"
        )
    ]
)
