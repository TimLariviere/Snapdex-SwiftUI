// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "SnapdexData",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(
            name: "SnapdexData",
            targets: ["SnapdexData"]),
    ],
    dependencies: [
        .package(path: "../SnapdexDomain"),
        .package(url: "https://github.com/firebase/firebase-ios-sdk", .upToNextMajor(from: "11.11.0")),
        .package(url: "https://github.com/groue/GRDB.swift.git", branch: "master")
    ],
    targets: [
        .target(
            name: "SnapdexData",
            dependencies: [
                "SnapdexDomain",
                .product(name: "FirebaseAuth", package: "firebase-ios-sdk"),
                .product(name: "FirebaseFirestore", package: "firebase-ios-sdk"),
                .product(name: "FirebaseCrashlytics", package: "firebase-ios-sdk"),
                .product(name: "GRDB", package: "GRDB.swift")
            ]
        )
    ]
)
