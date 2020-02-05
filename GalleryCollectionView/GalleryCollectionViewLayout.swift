//
//  GalleryCollectionViewLayout.swift
//  GalleryCollectionView
//
//  Created by troff on 1/28/20.
//  Copyright © 2020 CD. All rights reserved.
//

import Foundation
import UIKit

// TODO: implement safe area (also change of safe area)
// assume as full-screen
public class GalleryCollectionViewLayout: UICollectionViewLayout {
    
    override open var collectionViewContentSize: CGSize {
        guard let collectionView = collectionView else {
            return .zero
        }
        var result = collectionView.bounds.size
        let count = collectionView.numberOfTotalItems
        result.width = collectionView.bounds.width * CGFloat(count)
        return result
    }
    
    override open func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let collectionView = collectionView else {
            print("error, return nil")
            return nil
        }
        let bounds = collectionView.bounds
        guard bounds.width > 0 else {
            print("error, return nil")
            return nil
        }
        let totalCount = collectionView.numberOfTotalItems
        var startIdx = Int(floor(rect.minX / bounds.width))
        startIdx = max(startIdx, 0)
        startIdx = min(startIdx, (totalCount - 1))
        var upToIdx = Int(ceil(rect.maxX / bounds.width))
        upToIdx = min(upToIdx, totalCount)
        guard
            startIdx >= 0,
            startIdx < upToIdx
            else {
                print("error, return nil")
                return nil
        }
        let result: [UICollectionViewLayoutAttributes] = (startIdx..<upToIdx).compactMap {
            let path = IndexPath(item: $0, section: 0)
            return layoutAttributesForItem(at: path)
        }
        return result
        // TODO: implement sectioning
    }
    
    override open func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let collectionView = collectionView else {
            return nil
        }
        let itemsBefore = collectionView.countOfItems(before: indexPath)
        let bounds = collectionView.bounds
        let frame = CGRect(x: CGFloat(itemsBefore) * bounds.width, y: 0, width: bounds.width, height: bounds.height)
        let result = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        result.frame = frame
        return result
    }
    
    override open func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        let result = !(collectionView?.bounds.equalTo(newBounds) ?? false)
        return result
    }
    
    override open func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint,
                                           withScrollingVelocity velocity: CGPoint) -> CGPoint {
        return proposedContentOffset
    }
}
