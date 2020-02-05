// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "GalleryCollectionView",
    products: [
        .library(name: "GalleryCollectionView",
                 targets: ["GalleryCollectionView"]),
    ],
    dependencies: [
        .package(url: "https://github.com/paveltrafimuk/View2ViewTransition", from: "1.3.2"),
    ],
    targets: [
        .target(name: "GalleryCollectionView",
                path: "GalleryCollectionView",
                dependencies: ["View2ViewTransition"])
    ]
)
