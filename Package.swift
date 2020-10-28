// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "GalleryCollectionView",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(name: "GalleryCollectionView",
                 targets: ["GalleryCollectionView"]),
    ],
    dependencies: [
        .package(url: "https://github.com/paveltrafimuk/View2ViewTransition", from: "1.4.7"),
        .package(url: "https://github.com/kean/Nuke", from: "9.1.2"),
    ],
    targets: [
        .target(name: "GalleryCollectionView",
                dependencies: ["View2ViewTransition", "Nuke"],
                path: "GalleryCollectionView")
    ]
)
