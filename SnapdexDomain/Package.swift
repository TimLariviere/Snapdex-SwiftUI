// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "SnapdexDomain",
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
