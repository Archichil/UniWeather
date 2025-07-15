// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "AIService",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "AIService",
            targets: ["AIService"]
        ),
    ],
    dependencies: [
        .package(name: "WeatherService", path: "../WeatherService"),
    ],
    targets: [
        .target(
            name: "AIService",
            dependencies: ["WeatherService"]
        ),
    ]
)
