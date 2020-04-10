//
//  GalleryDetailViewController.swift
//  GalleryCollectionView
//
//  Created by troff on 2/4/20.
//  Copyright © 2020 CD. All rights reserved.
//

import Foundation
import UIKit
import View2ViewTransition
import Nuke

open class GalleryDetailViewController: UIViewController {
    
    let layout = GalleryCollectionViewLayout()
    var collectionView: UICollectionView!
    
    public weak var transitionController: TransitionController!
    
    public var urls = [URLRequest]() {
        didSet {
            if isViewLoaded {
                collectionView.reloadData()
            }
        }
    }
    
    public var images = [UIImage]() {
        didSet {
            if isViewLoaded {
                collectionView.reloadData()
            }
        }
    }
    
    public func handleDismiss(animated: Bool) {
        guard let indexPath = collectionView.indexPathsForVisibleItems.first else {
            return
        }
        transitionController.context.destinationIndexPath = indexPath
        transitionController.context.initialIndexPath = indexPath
        dismiss(animated: true, completion: nil)
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView = GalleryCollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(GalleryCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
        ])
    }
}


extension GalleryDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if !urls.isEmpty {
            return urls.count
        }
        return images.count
    }
    
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellRaw = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        if let cell = cellRaw as? GalleryCollectionViewCell {
            if !urls.isEmpty {
                let imageRequest = ImageRequest(urlRequest: urls[indexPath.item])
                Nuke.loadImage(with: imageRequest,
                               into: cell.imageView) { _ in
                                cell.setupInitialZoom()
                }
            }
            else {
                let image = images[indexPath.item]
                cell.imageView.image = image
                cell.setupInitialZoom()
            }
        }
        return cellRaw
    }
}


extension GalleryDetailViewController: View2ViewTransitionPresented {
    
    public func destinationFrame(_ context: TransitionControllerContext, isPresenting: Bool) -> CGRect {
        guard
            let indexPath = context.destinationIndexPath,
            let cell = collectionView.cellForItem(at: indexPath) as? GalleryCollectionViewCell
            else {
                return .zero
        }
        let result = cell.contentView.convert(cell.imageView.frame, from: cell.imageView.superview)
        return result
    }
    
    public func destinationView(_ context: TransitionControllerContext, isPresenting: Bool) -> UIView {
        guard
            let indexPath = context.destinationIndexPath,
            let cell = collectionView.cellForItem(at: indexPath) as? GalleryCollectionViewCell
            else {
                return UIView()
        }
        return cell.imageView
    }
    
    public func prepareDestinationView(_ context: TransitionControllerContext, isPresenting: Bool) {
        
        if isPresenting {
            guard
                let indexPath = context.destinationIndexPath
                else {
                    return
            }
            let contentOfffset: CGPoint = CGPoint(x: self.collectionView.frame.size.width*CGFloat(indexPath.item), y: 0.0)
            self.collectionView.contentOffset = contentOfffset
            
            self.collectionView.reloadData()
            self.collectionView.layoutIfNeeded()
        }
        else {
            guard let indexPath = collectionView.indexPathsForVisibleItems.first else {
                return
            }
            transitionController.context.destinationIndexPath = indexPath
            transitionController.context.initialIndexPath = indexPath
        }
    }
}
