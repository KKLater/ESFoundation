// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ESFoundation",
    products: [
        .library(name: "ESFoundation", targets: ["ESDate", "ESArray", "ESString", "ESDispatchQueue", "ESNotification", "ESTime", "ESCache"]),
        .library(name: "ESDate", targets: ["ESDate", "ESCache"]),
        .library(name: "ESArray", targets: ["ESArray"]),
        .library(name: "ESString", targets: ["ESString"]),
        .library(name: "ESDispatchQueue", targets: ["ESDispatchQueue"]),
        .library(name: "ESNotification", targets: ["ESNotification"]),
        .library(name: "ESTime", targets: ["ESTime"]),

    ],
    dependencies: [

    ],
    targets: [
        .target(name: "ESCache", dependencies: [], path: "Sources/ESFoundation", sources: ["Cache"]),
        .target(name: "ESDate", dependencies: [], path: "Sources/ESFoundation", sources: ["Date"]),
        .target(name: "ESArray", dependencies: [], path: "Sources/ESFoundation", sources: ["Array"]),
        .target(name: "ESString", dependencies: [], path: "Sources/ESFoundation", sources: ["String"]),
        .target(name: "ESDispatchQueue", dependencies: [], path: "Sources/ESFoundation", sources: ["DispatchQueue"]),
        .target(name: "ESNotification", dependencies: [], path: "Sources/ESFoundation", sources: ["Notification"]),
        .target(name: "ESTime", dependencies: [], path: "Sources/ESFoundation", sources: ["Time"]),
        .testTarget(name: "ESFoundationArrayTests", dependencies: ["ESArray"], path: "Tests/ESFoundationTests/ESFoundationArrayTests"),
        .testTarget(name: "ESFoundationStringTests", dependencies: ["ESString"], path: "Tests/ESFoundationTests/ESFoundationStringTests"),

    ]
)
