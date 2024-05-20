// swift-tools-version: 5.9
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
            url: "https://cdn.camelqa.com/iOS/qaml-1.0.5.xcframework.zip",
            checksum: "dbc6bab1a7d4e3b2ad917a3cd7fa96d218c1c8349c4463b9b5500594797c61fd"
            ),
    ]
)
