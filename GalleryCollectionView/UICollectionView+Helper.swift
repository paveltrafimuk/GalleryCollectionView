//
//  UICollectionView+Helper.swift
//  GalleryCollectionView
//
//  Created by troff on 1/28/20.
//  Copyright © 2020 CD. All rights reserved.
//

import Foundation
import UIKit

extension UICollectionView {
    public var numberOfTotalItems: Int {
        let sectionCount = numberOfSections
        var result = 0
        for i in 0..<sectionCount {
            result += numberOfItems(inSection: i)
        }
        return result
    }
    
    public func countOfItems(before indexPath: IndexPath) -> Int {
        let sectionCount = numberOfSections
        let maxSection = min(indexPath.section, (sectionCount - 1))
        guard maxSection >= 0 else {
            return 0
        }
        var result = 0
        for i in 0...maxSection {
            let countOfItems = numberOfItems(inSection: i)
            if i == indexPath.section {
                result += min(countOfItems, indexPath.item)
            }
            else {
                result += countOfItems
            }
        }
        return result
    }
}
