// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BonMot",
    platforms: [
        .iOS(.v10),
        .macOS(.v10_11),
        .tvOS(.v10),
        .watchOS(.v2),
    ],
    products: [
        .library(
            name: "BonMot",
            targets: ["BonMot"]),
    ],
    targets: [
        .target(
            name: "BonMot",
            dependencies: [],
            path: "Sources"),
        // Test targets do not currently support including resource files,
        // which these tests depend on. Revisit when resources are supported.
//        .testTarget(
//            name: "BonMotTests",
//            dependencies: ["BonMot"],
//            path: "Tests"),
    ]
)
