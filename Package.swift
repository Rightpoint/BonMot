// swift-tools-version:5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BonMot",
    platforms: [
        .iOS(.v12),
        .macOS(.v10_13),
        .tvOS(.v12),
        .watchOS(.v4),
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
            path: "Sources",
            exclude: ["Info.plist"]
        ),
        .testTarget(
            name: "BonMotTests",
            dependencies: ["BonMot"],
            path: "Tests",
            exclude: [
                "Info.plist",
                "BonMot-iOSTests.xctestplan", // *.xctestplan didn't seem to work
                "BonMot-OSXTests.xctestplan",
                "BonMot-tvOSTests.xctestplan",
            ],
            resources: [
                .process("Resources"),
        ]),
    ],
    swiftLanguageVersions: [.v5]
)
