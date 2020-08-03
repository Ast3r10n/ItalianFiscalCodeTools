// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ItalianFiscalCodeTools",
    products: [
        .library(
            name: "ItalianFiscalCodeTools",
            targets: ["ItalianFiscalCodeTools"]),
    ],
    targets: [
        .target(
            name: "ItalianFiscalCodeTools",
            dependencies: []),
        .testTarget(
            name: "ItalianFiscalCodeToolsTests",
            dependencies: ["ItalianFiscalCodeTools"]),
    ]
)
