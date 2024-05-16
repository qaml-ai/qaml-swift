// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "package",
    products: [
        .library(
            name: "qaml",
            targets: ["qaml"]),
    ],
    targets: [
        .binaryTarget(
            name: "qaml",
            url: "https://cdn.camelqa.com/iOS/qaml-1.0.3.xcframework.zip",
            checksum: "59db9a5eb4347c3280a45e1cafabf839767300b860f2eeb61f854bcd51e26024"
            ),
    ]
)
