//
//  UIView+Constraints.swift
//  GalleryCollectionView
//
//  Created by troff on 1/29/20.
//  Copyright © 2020 CD. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    @discardableResult
    open func alignToSuperViewEdges(activate: Bool = true) -> [NSLayoutConstraint] {
        guard let superview = superview else { return [] }
        let result = [
            leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: 0),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: 0),
            topAnchor.constraint(equalTo: superview.topAnchor, constant: 0),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: 0),
        ]
        if activate {
            NSLayoutConstraint.activate(result)
        }
        return result
    }
}
