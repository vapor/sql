// swift-tools-version:4.1
import PackageDescription

let package = Package(
    name: "SQL",
    products: [
        .library(name: "SQL", targets: ["SQL"]),
        .library(name: "SQLBenchmark", targets: ["SQLBenchmark"]),
    ],
    dependencies: [
        // 🗄 Core services for creating database integrations.
        .package(url: "https://github.com/vapor/database-kit.git", from: "1.2.0"),
    ],
    targets: [
        .target(name: "SQL", dependencies: ["DatabaseKit"]),
        .target(name: "SQLBenchmark", dependencies: ["SQL"]),
        .testTarget(name: "SQLTests", dependencies: ["SQL"]),
    ]
)
