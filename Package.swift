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
            url: "https://cdn.camelqa.com/iOS/qaml-1.0.4.xcframework.zip",
            checksum: "5dced1f0a4f4acf58189928d18b34eee8e96d821315b2b372f39bcb1cbdb7039"
            ),
    ]
)
