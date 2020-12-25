// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ESFoundation",
    platforms: [.iOS(.v9), .macOS(.v10_10), .tvOS(.v10), .watchOS(.v3)],
    products: [
        .library(name: "ESDictionary", targets: ["ESDictionary"]),
        .library(name: "ESTransition", targets: ["ESTransition"]),
        .library(name: "ESTimer", targets: ["ESTimer"]),
        .library(name: "ESDate", targets: ["ESDate"]),
        .library(name: "ESData", targets: ["ESData"]),
        .library(name: "ESCache", targets: ["ESCache"]),
        .library(name: "ESArray", targets: ["ESArray"]),
        .library(name: "ESString", targets: ["ESString", "ESString"]),
        .library(name: "ESDispatchQueue", targets: ["ESDispatchQueue"]),
        .library(name: "ESNotification", targets: ["ESNotification"]),
        .library(name: "ESTime", targets: ["ESTime"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(name: "ESCache", dependencies: ["ESString"], path: "Sources/ESFoundation", sources: ["Cache"]),
        .target(name: "ESDictionary", dependencies: [], path: "Sources/ESFoundation", sources: ["Dictionary"]),
        .target(name: "ESTransition", dependencies: [], path: "Sources/ESFoundation", sources: ["Transition"]),
        .target(name: "ESData", dependencies: [], path: "Sources/ESFoundation", sources: ["Data"]),
        .target(name: "ESDate", dependencies: ["ESCache"], path: "Sources/ESFoundation", sources: ["Date"]),
        .target(name: "ESArray", dependencies: [], path: "Sources/ESFoundation", sources: ["Array"]),
        .target(name: "ESString", dependencies: [], path: "Sources/ESFoundation", sources: ["String"]),
        .target(name: "ESDispatchQueue", dependencies: [], path: "Sources/ESFoundation", sources: ["DispatchQueue"]),
        .target(name: "ESNotification", dependencies: [], path: "Sources/ESFoundation", sources: ["Notification"]),
        .target(name: "ESTime", dependencies: [], path: "Sources/ESFoundation", sources: ["Time"]),
        .target(name: "ESTimer", dependencies: [], path: "Sources/ESFoundation", sources: ["Timer"]),
        .testTarget(name: "ESFoundationArrayTests", dependencies: ["ESArray"], path: "Tests/ESFoundationTests/ESFoundationArrayTests"),
        .testTarget(name: "ESFoundationStringTests", dependencies: ["ESString"], path: "Tests/ESFoundationTests/ESFoundationStringTests"),
        .testTarget(name: "ESFoundationDateFormatterTests", dependencies: ["ESDate"], path: "Tests/ESFoundationTests/ESFoundationDateFormatterTests"),
        .testTarget(name: "ESFoundationTimerTests", dependencies: ["ESTimer"], path: "Tests/ESFoundationTests/ESFoundationTimerTests"),
    ]
)
