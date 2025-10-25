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
        .package(url: "https://github.com/Archichil/swift-api-client.git", from: "1.0.2"),
    ],
    targets: [
        .target(
            name: "AIService",
            dependencies: [
                .product(name: "APIClient", package: "swift-api-client"),
            ],
            path: "Source"
        ),
    ]
)
