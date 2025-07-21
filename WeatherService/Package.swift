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
        .package(url: "https://github.com/Archichil/swift-api-client.git", from: "1.0.2")
    ],
    targets: [
        .target(
            name: "WeatherService",
            dependencies: [
                .product(name: "APIClient", package: "swift-api-client")
            ]
        ),
    ]
)
