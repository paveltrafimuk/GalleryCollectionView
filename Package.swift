// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "GalleryCollectionView",
    products: [
        .library(name: "GalleryCollectionView",
                 targets: ["GalleryCollectionView"]),
    ],
    targets: [
        .target(
            name: "GalleryCollectionView",
            path: "GalleryCollectionView")
    ]
)
