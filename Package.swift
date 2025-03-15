// swift-tools-version:6.0
import PackageDescription

let package = Package(
    name: "Coin",
    platforms: [.iOS(.v15), .macOS(.v12)],
    products: [
        .library(
            name: "Coin",
            targets: ["Coin"]),
        .library(
            name: "CoinWidget",
            targets: ["CoinWidget"])
    ],
    dependencies: [
        .package(url: "https://github.com/Swinject/Swinject.git", from: "2.8.8")
    ],
    targets: [
        .target(
            name: "Coin",
            dependencies: ["Swinject"]),
        .target(
            name: "CoinWidget",
            dependencies: ["Coin"]),
        .testTarget(
            name: "CoinTests",
            dependencies: ["Coin"])
    ]
)