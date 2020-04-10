//
//  GalleryCollectionViewCell.swift
//  GalleryCollectionView
//
//  Created by troff on 1/29/20.
//  Copyright © 2020 CD. All rights reserved.
//
//  Thanks to Evgenii Neumerzhitckii

import Foundation
import UIKit

open class GalleryCollectionViewCell: UICollectionViewCell {
    
    public let scrollView = UIScrollView()
    public let imageView = UIImageView()
    
    let doubleTap = UITapGestureRecognizer()
    var fillZoomValue: CGFloat = 1
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alignToSuperViewEdges()
        scrollView.delegate = self
        scrollView.maximumZoomScale = 4.0
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        scrollView.addSubview(imageView)
        imageView.alignToSuperViewEdges()
        
        doubleTap.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(doubleTap)
        doubleTap.addTarget(self, action: #selector(doubleTapDidTap))
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setupInitialZoom() {
        UIView.performWithoutAnimation {
            scrollView.layoutIfNeeded()
            updateZoomValues(animated: false)
            scrollView.zoomScale = scrollView.minimumZoomScale
            updateInsets()
        }
    }
    
    public func updateZoomValues(animated: Bool) {
        guard let image = imageView.image else {
            scrollView.minimumZoomScale = 1
            fillZoomValue = 1
            return
        }
        let minZoom = min(scrollView.bounds.size.width / image.size.width,
                            scrollView.bounds.size.height / image.size.height)
        let maxZoom = max(scrollView.bounds.size.width / image.size.width,
                            scrollView.bounds.size.height / image.size.height)
        scrollView.minimumZoomScale = minZoom
        fillZoomValue = maxZoom
        if scrollView.zoomScale < scrollView.minimumZoomScale {
            scrollView.setZoomScale(minZoom, animated: animated)
        }
    }
    
    func updateInsets() {
        let heightDelta = scrollView.bounds.height - scrollView.contentSize.height
        if heightDelta > 0 {
            scrollView.contentInset.top = heightDelta / 2.0
        }
        else {
            scrollView.contentInset.top = 0.0
        }
        
        let widthDelta = scrollView.bounds.width - scrollView.contentSize.width
        if widthDelta > 0 {
            scrollView.contentInset.left = widthDelta / 2.0
        }
        else {
            scrollView.contentInset.left = 0.0
        }
    }
    
    func revertToMinValues() {
        updateZoomValues(animated: false)
        scrollView.setZoomScale(scrollView.minimumZoomScale, animated: true)
        updateInsets()
        revertContentOffset()
    }
    
    func revertContentOffset() {
        let point = CGPoint(x: -scrollView.contentInset.left, y: -scrollView.contentInset.top)
        scrollView.setContentOffset(point, animated: true)
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        revertToMinValues()
    }
    
    override open func updateConstraints() {
        super.updateConstraints()
        updateInsets()
    }
    
    @objc func doubleTapDidTap() {
        if scrollView.zoomScale > scrollView.minimumZoomScale {
            scrollView.setZoomScale(scrollView.minimumZoomScale, animated: true)
        }
        else {
            scrollView.setZoomScale(fillZoomValue, animated: true)
        }
    }
}

extension GalleryCollectionViewCell: UIScrollViewDelegate {
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    public func scrollViewDidZoom(_ scrollView: UIScrollView) {
        updateInsets()
    }
}
