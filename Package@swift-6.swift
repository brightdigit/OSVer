// swift-tools-version: 6.0

import PackageDescription

// swiftlint:disable:next explicit_acl explicit_top_level_acl
let package = Package(
  name: "OSVer",
  products: [
    .library(
      name: "OSVer",
      targets: ["OSVer"]
    )
  ],
  targets: [
    .target(
      name: "OSVer"
    ),
    .testTarget(
      name: "OSVerTests",
      dependencies: ["OSVer"]
    )
  ]
)
