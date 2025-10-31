// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "CodexSwiftUIApp",
    platforms: [
        .iOS("26.0")
    ],
    products: [
        .executable(name: "CodexSwiftUIApp", targets: ["CodexSwiftUIApp"])
    ],
    dependencies: [
        .package(url: "https://github.com/stephencelis/SQLite.swift.git", from: "0.15.0")
    ],
    targets: [
        .executableTarget(
            name: "CodexSwiftUIApp",
            dependencies: [
                .product(name: "SQLite", package: "SQLite.swift")
            ],
            path: "Sources",
            resources: [],
            swiftSettings: []
        ),
        .testTarget(
            name: "CodexSwiftUIAppTests",
            dependencies: ["CodexSwiftUIApp"],
            path: "Tests"
        )
    ]
)
