// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "WeatherMapService",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "WeatherMapService",
            targets: ["WeatherMapService"]
        ),
    ],
    dependencies: [
        .package(name: "WeatherService", path: "../WeatherService"),
    ],
    targets: [
        .target(
            name: "WeatherMapService",
            dependencies: ["WeatherService"]
        ),
    ]
)
