// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BonMot",
    platforms: [
        .iOS(.v9),
        .macOS(.v10_11),
        .tvOS(.v9),
        .watchOS(.v2),
    ],
    products: [
        .library(
            name: "BonMot",
            targets: ["BonMot"])
    ],
    targets: [
        .target(
            name: "BonMot",
            path: "Sources"),
        .testTarget(
            name: "BonMotTests",
            dependencies: ["BonMot"],
            path: "Tests")
    ]
)
