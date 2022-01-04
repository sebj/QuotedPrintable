// swift-tools-version:5.0

//  Created by Johannes Schriewer on 2015-12-20.
//  Copyright © 2015 Johannes Schriewer. All rights reserved.

import PackageDescription

let package = Package(
    name: "QuotedPrintable",
    targets: [
        .target(name: "QuotedPrintable"),
        .testTarget(name: "QuotedPrintableTests", dependencies: ["QuotedPrintable"])
    ]
)
