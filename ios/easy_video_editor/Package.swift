// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "easy_video_editor",
    platforms: [
        .iOS("15.0")
    ],
    products: [
        .library(name: "easy-video-editor", targets: ["easy_video_editor"])
    ],
    dependencies: [
        // Canonical Flutter SPM plugin template shape: flutter_tools rewrites this
        // path dependency at integration time, so keep it as templated.
        .package(name: "FlutterFramework", path: "../FlutterFramework")
    ],
    targets: [
        .target(
            name: "easy_video_editor",
            dependencies: [
                .product(name: "FlutterFramework", package: "FlutterFramework")
            ],
            resources: [
                // If this plugin adds a privacy manifest or other bundled resources, process them here.
            ]
        )
    ]
)
