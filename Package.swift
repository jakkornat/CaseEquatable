// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "CaseEquatable",
    platforms: [.macOS(.v10_15), .iOS(.v13), .tvOS(.v13), .watchOS(.v6), .macCatalyst(.v13)],
    products: [
        .library(
            name: "CaseEquatable",
            targets: ["CaseEquatable"]
        ),
        .executable(
            name: "CaseEquatableClient",
            targets: ["CaseEquatableClient"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/swiftlang/swift-syntax.git", from: "600.0.0-latest"),
    ],
    targets: [
        .macro(
            name: "CaseEquatableMacros",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax")
            ]
        ),
        .target(name: "CaseEquatable", dependencies: ["CaseEquatableMacros"]),
        .executableTarget(name: "CaseEquatableClient", dependencies: ["CaseEquatable"]),
        .testTarget(
            name: "CaseEquatableTests",
            dependencies: [
                "CaseEquatableMacros",
                .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax"),
            ]
        ),
    ]
)
