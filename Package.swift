// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "apple-maps-kit",
    platforms: [
        .macOS(.v14)
    ],
    products: [
        .library(name: "AppleMapsKit", targets: ["AppleMapsKit"])
    ],
    dependencies: [
        .package(url: "https://github.com/swift-server/async-http-client.git", from: "1.23.0"),
        .package(url: "https://github.com/vapor/jwt-kit.git", from: "5.0.1"),
    ],
    targets: [
        .target(
            name: "AppleMapsKit",
            dependencies: [
                .product(name: "AsyncHTTPClient", package: "async-http-client"),
                .product(name: "JWTKit", package: "jwt-kit"),
            ],
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "AppleMapsKitTests",
            dependencies: [
                .target(name: "AppleMapsKit")
            ],
            swiftSettings: swiftSettings
        ),
    ]
)

var swiftSettings: [SwiftSetting] {
    [
        .enableUpcomingFeature("ExistentialAny")
    ]
}
