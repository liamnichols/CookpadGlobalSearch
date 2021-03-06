// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "CookpadGlobalSearch",
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "3.1.1")
    ],
    targets: [
        .target(name: "App", dependencies: ["Vapor"]),
        .target(name: "Run", dependencies: ["App"]),
        .testTarget(name: "AppTests", dependencies: ["App"])
    ]
)

