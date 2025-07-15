// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "WeatherService",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "WeatherService",
            targets: ["WeatherService"]
        ),
    ],
    dependencies: [
        .package(name: "APIClient", path: "../APIClient"),
    ],
    targets: [
        .target(
            name: "WeatherService",
            dependencies: ["APIClient"]
        ),
    ]
)
