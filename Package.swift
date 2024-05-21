// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "qaml",
    platforms: [
        .iOS(.v13),
        .macOS(.v11),
    ],
    products: [
        .library(
            name: "qaml",
            targets: ["qaml"]),
    ],
    targets: [
        .target(
            name: "qaml",
            dependencies: []
        )
    ]
)
