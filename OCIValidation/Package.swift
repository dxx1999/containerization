// swift-tools-version: 6.2
import PackageDescription

// Links unchanged repository sources and pins the repository's direct OCI dependencies.
let package = Package(
    name: "OCIValidation",
    platforms: [.macOS("15")],
    dependencies: [
        .package(url: "https://github.com/apple/swift-nio.git", exact: "2.101.3"),
        .package(url: "https://github.com/apple/swift-nio-ssl.git", exact: "2.37.2"),
        .package(url: "https://github.com/swift-server/async-http-client.git", exact: "1.35.0"),
        .package(url: "https://github.com/apple/swift-crypto.git", exact: "3.15.1"),
        .package(url: "https://github.com/apple/swift-log.git", exact: "1.14.0"),
        .package(url: "https://github.com/apple/swift-collections.git", exact: "1.5.1"),
        .package(url: "https://github.com/apple/swift-system.git", exact: "1.7.5"),
        .package(url: "https://github.com/apple/swift-algorithms.git", exact: "1.2.1"),
        .package(url: "https://github.com/apple/swift-asn1.git", exact: "1.7.1"),
        .package(url: "https://github.com/apple/swift-async-algorithms.git", exact: "1.1.5"),
        .package(url: "https://github.com/apple/swift-atomics.git", exact: "1.3.1"),
        .package(url: "https://github.com/apple/swift-certificates.git", exact: "1.19.3"),
        .package(url: "https://github.com/apple/swift-http-structured-headers.git", exact: "1.7.0"),
        .package(url: "https://github.com/apple/swift-http-types.git", exact: "1.6.0"),
        .package(url: "https://github.com/apple/swift-nio-extras.git", exact: "1.34.3"),
        .package(url: "https://github.com/apple/swift-nio-http2.git", exact: "1.44.0"),
        .package(url: "https://github.com/apple/swift-nio-transport-services.git", exact: "1.28.0"),
        .package(url: "https://github.com/apple/swift-numerics.git", exact: "1.1.1"),
        .package(url: "https://github.com/swift-server/swift-service-lifecycle", exact: "2.12.0"),
        .package(url: "https://github.com/apple/swift-configuration.git", exact: "1.2.0", traits: []),
        .package(url: "https://github.com/apple/swift-distributed-tracing.git", exact: "1.4.1"),
        .package(url: "https://github.com/apple/swift-service-context.git", exact: "1.3.0"),
    ],
    targets: [
        .target(name: "CShim"),
        .target(name: "ContainerizationError"),
        .target(name: "ContainerizationOS", dependencies: [
            "CShim", "ContainerizationError",
            .product(name: "Logging", package: "swift-log"),
            .product(name: "SystemPackage", package: "swift-system"),
        ], exclude: ["README.md"]),
        .target(name: "ContainerizationExtras", dependencies: [
            "ContainerizationError",
            .product(name: "Collections", package: "swift-collections"),
            .product(name: "Logging", package: "swift-log"),
            .product(name: "NIOSSL", package: "swift-nio-ssl"),
        ]),
        .target(name: "ContainerizationOCI", dependencies: [
            "ContainerizationError", "ContainerizationOS", "ContainerizationExtras",
            .product(name: "AsyncHTTPClient", package: "async-http-client"),
            .product(name: "Crypto", package: "swift-crypto"),
            .product(name: "Logging", package: "swift-log"),
            .product(name: "_NIOFileSystem", package: "swift-nio"),
        ]),
        .testTarget(name: "ContainerizationOCITests", dependencies: [
            "ContainerizationOCI",
            .product(name: "NIOPosix", package: "swift-nio"),
            .product(name: "NIOHTTP1", package: "swift-nio"),
            .product(name: "Crypto", package: "swift-crypto"),
        ]),
    ]
)
