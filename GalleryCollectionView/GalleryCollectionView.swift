//
//  GalleryCollectionView.swift
//  GalleryCollectionView
//
//  Created by troff on 1/29/20.
//  Copyright © 2020 CD. All rights reserved.
//

import Foundation
import UIKit

open class GalleryCollectionView: UICollectionView {
    public override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        isPagingEnabled = true
        contentInsetAdjustmentBehavior = .never
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }    
}
