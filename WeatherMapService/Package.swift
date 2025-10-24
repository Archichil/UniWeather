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
        .package(url: "https://github.com/Archichil/swift-api-client.git", from: "1.0.2"),
    ],
    targets: [
        .target(
            name: "WeatherMapService",
            dependencies: [
                .product(name: "APIClient", package: "swift-api-client"),
            ],
            path: "Source"
        ),
    ]
)
