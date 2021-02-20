// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "swift-algorand-sdk",
    platforms: [
          .macOS(.v10_12),
           .iOS(.v10),
           .tvOS(.v10),
           .watchOS(.v3)
      ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "swift-algorand-sdk",
            targets: ["swift-algorand-sdk"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
//        .package(url:  "https://github.com/vzsg/ed25519.git", .upToNextMajor(from: "0.1.0"))
//        .package(url: "https://github.com/AndrewBarba/ed25519.git", .upToNextMajor(from: "1.1.0")),
        .package(name:"Ed25519",url: "https://github.com/AndrewBarba/ed25519.git", .branch("master")),
        .package(name:"swift-crypto", url: "https://github.com/apple/swift-crypto.git", .branch("main")),
        .package(
            url: "https://github.com/Flight-School/MessagePack",
            from: "1.2.3"
        ),
        .package(name:"MessagePacker", url: "https://github.com/hirotakan/MessagePacker.git", from: "0.0.0"),
        .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.2.0"))
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "swift-algorand-sdk",
            
            dependencies: ["Ed25519","MessagePack","MessagePacker","Alamofire"]),
        .testTarget(
            name: "swift-algorand-sdkTests",
            dependencies: ["swift-algorand-sdk"]),
    ]
)
