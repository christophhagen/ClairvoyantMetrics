// swift-tools-version: 5.8

import PackageDescription

let package = Package(
    name: "ClairvoyantMetrics",
    platforms: [.macOS(.v12), .iOS(.v14), .watchOS(.v9)],
    products: [
        .library(
            name: "ClairvoyantMetrics",
            targets: ["ClairvoyantMetrics"]),
    ],
    dependencies: [
        .package(url: "https://github.com/christophhagen/Clairvoyant", from: "0.9.2"),
        .package(url: "https://github.com/apple/swift-metrics.git", from: "2.4.0"),
    ],
    targets: [
        .target(
            name: "ClairvoyantMetrics",
            dependencies: [
                .product(name: "Clairvoyant", package: "Clairvoyant"),
                .product(name: "Metrics", package: "swift-metrics"),
            ]),
        .testTarget(
            name: "ClairvoyantMetricsTests",
            dependencies: ["ClairvoyantMetrics"]),
    ]
)
