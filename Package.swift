// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "HZPlaceHolder",
    platforms: [
        .iOS(.v11)
    ],
    products: [
        .library(
            name: "HZPlaceHolder",
            targets: ["HZPlaceHolder"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/CoderMJLee/MJRefresh.git", from: "3.7.1")
    ],
    targets: [
        .target(
            name: "HZPlaceHolder",
            dependencies: [
                .product(name: "MJRefresh", package: "MJRefresh")
            ],
            path: "HZPlaceHolder"
        )
    ],
    swiftLanguageVersions: [.v5]
)
