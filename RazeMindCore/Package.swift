// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "RazeMindCore", platforms: [.iOS("15.6")],
    products: [
        .library(
            name: "RazeMindCore",
            targets: ["RazeMindCore"]),
    ],
    dependencies: [
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "RazeMindCore",
            dependencies: []),
        .testTarget(
            name: "RazeMindCoreTests",
            dependencies: ["RazeMindCore"]),
    ]
)
