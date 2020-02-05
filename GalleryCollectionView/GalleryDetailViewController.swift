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

open class GalleryDetailViewController: UIViewController {
    
    let layout = GalleryCollectionViewLayout()
    var collectionView: UICollectionView!
    
    public weak var transitionController: TransitionController!
    
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
        transitionController.userInfo = ["destinationIndexPath": indexPath, "initialIndexPath": indexPath]
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
        images.count
    }
    
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellRaw = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        if let cell = cellRaw as? GalleryCollectionViewCell {
            let image = images[indexPath.item]
            cell.imageView.image = image
            cell.setupInitialZoom()
        }
        return cellRaw
    }
}


extension GalleryDetailViewController: View2ViewTransitionPresented {
    // MARK: Gesture Delegate
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let panGestureRecognizer: UIPanGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer else {
            return true
        }
        guard let indexPath = collectionView.indexPathsForVisibleItems.first else {
            return false
        }
        transitionController.userInfo = ["destinationIndexPath": indexPath, "initialIndexPath": indexPath]
        let transate: CGPoint = panGestureRecognizer.translation(in: view)
        return Double(abs(transate.y)/abs(transate.x)) > .pi / 4.0
    }
    
    public func destinationFrame(_ userInfo: [String: Any]?, isPresenting: Bool) -> CGRect {
        guard
            let indexPath = userInfo?["destinationIndexPath"] as? IndexPath,
            let cell = collectionView.cellForItem(at: indexPath) as? GalleryCollectionViewCell
            else {
                return .zero
        }
        let result = cell.contentView.convert(cell.imageView.frame, from: cell.imageView.superview)
        return result
    }
    
    public func destinationView(_ userInfo: [String: Any]?, isPresenting: Bool) -> UIView {
        guard
            let indexPath = userInfo?["destinationIndexPath"] as? IndexPath,
            let cell = collectionView.cellForItem(at: indexPath) as? GalleryCollectionViewCell
            else {
                return UIView()
        }
        return cell.imageView
    }
    
    public func prepareDestinationView(_ userInfo: [String: Any]?, isPresenting: Bool) {
        
        if isPresenting {
            guard
                let indexPath = userInfo?["destinationIndexPath"] as? IndexPath
                else {
                    return
            }
            let contentOfffset: CGPoint = CGPoint(x: self.collectionView.frame.size.width*CGFloat(indexPath.item), y: 0.0)
            self.collectionView.contentOffset = contentOfffset
            
            self.collectionView.reloadData()
            self.collectionView.layoutIfNeeded()
        }
    }
}
