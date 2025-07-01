// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "CodexSwiftUIApp",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .executable(name: "CodexSwiftUIApp", targets: ["CodexSwiftUIApp"])
    ],
    dependencies: [],
    targets: [
        .executableTarget(
            name: "CodexSwiftUIApp",
            path: ".",
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
