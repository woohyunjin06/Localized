// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "Localized",
    platforms: [.macOS(.v10_15), .iOS(.v13), .tvOS(.v13), .watchOS(.v6), .macCatalyst(.v13)],
    products: [
        .library(
            name: "Localized",
            targets: ["Localized"]
        ),
        .executable(
            name: "LocalizedClient",
            targets: ["LocalizedClient"]
        ),
    ],
    dependencies: [
        // Depend on the latest Swift 5.9 prerelease of SwiftSyntax
        .package(url: "https://github.com/apple/swift-syntax.git", from: "509.0.0-swift-DEVELOPMENT-SNAPSHOT-2023-08-15-a"),
    ],
    targets: [
        .macro(
            name: "LocalizedMacros",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax")
            ]
        ),
        .target(name: "Localized", dependencies: ["LocalizedMacros"]),
        .executableTarget(name: "LocalizedClient", dependencies: ["Localized"]),
        .testTarget(
            name: "LocalizedMacroTests",
            dependencies: [
                "LocalizedMacros",
                .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax"),
            ]
        ),
        .testTarget(
            name: "LocalizedTests",
            dependencies: [
                "Localized",
                .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax"),
            ]
        ),
    ]
)
