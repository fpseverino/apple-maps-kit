// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "apple-maps-kit",
    platforms: [
        .macOS(.v14),
    ],
    products: [
        .library(name: "AppleMapsKit", targets: ["AppleMapsKit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/swift-server/async-http-client.git", from: "1.22.0"),
        .package(url: "https://github.com/vapor/jwt-kit.git", from: "5.0.0-rc.2"),
    ],
    targets: [
        .target(
            name: "AppleMapsKit",
            dependencies: [
                .product(name: "AsyncHTTPClient", package: "async-http-client"),
                .product(name: "JWTKit", package: "jwt-kit"),
            ]
        ),
        .testTarget(
            name: "AppleMapsKitTests",
            dependencies: [
                .target(name: "AppleMapsKit"),
            ]
        ),
    ]
)
