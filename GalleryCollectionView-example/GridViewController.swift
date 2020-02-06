//
//  GridViewController.swift
//  GalleryCollectionView-example
//
//  Created by troff on 1/30/20.
//  Copyright © 2020 CD. All rights reserved.
//

import Foundation
import UIKit
import GalleryCollectionView
import View2ViewTransition

open class GridCollectionViewCell: UICollectionViewCell {
    
    public let imageView = UIImageView()
        
    override public init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.alignToSuperViewEdges()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class GridViewController: UIViewController {

    let images = (1...10).map { "b\($0)" }
    
    let layout = UICollectionViewFlowLayout()
    
    var collectionView: UICollectionView!
    
    public let transitionController: TransitionController = TransitionController()
    
    var selectedIndexPath: IndexPath = IndexPath(item: 0, section: 0)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        layout.itemSize = .init(width: 180.0, height: 180.0)
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(GridCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        view.addSubview(collectionView)
        collectionView.alignToSuperViewEdges()
    }
}

extension GridViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellRaw = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        if let cell = cellRaw as? GridCollectionViewCell {
            let imageName = images[indexPath.item]
            let img = UIImage(named: imageName)
            cell.imageView.image = img
        }
        return cellRaw
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedIndexPath = indexPath

        let presentedViewController = GalleryDetailViewController()
        presentedViewController.modalPresentationStyle = .custom
        presentedViewController.images = images.map({ UIImage(named: $0 )! })
        presentedViewController.transitionController = self.transitionController
        
        transitionController.context.destinationIndexPath = indexPath
        transitionController.context.initialIndexPath = indexPath
        
        // This example will push view controller if presenting view controller has navigation controller.
        // Otherwise, present another view controller
//        if let navigationController = self.navigationController {

//            // Set transitionController as a navigation controller delegate and push.
//            navigationController.delegate = transitionController
//            transitionController.push(viewController: presentedViewController, on: self, attached: presentedViewController)
//
//        } else {
            
            // Set transitionController as a transition delegate and present.
            presentedViewController.transitioningDelegate = transitionController
            transitionController.present(viewController: presentedViewController, on: self, attached: presentedViewController, completion: nil)
//        }
        
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}


extension GridViewController: View2ViewTransitionPresenting {
    
    func initialFrame(_ context: TransitionControllerContext, isPresenting: Bool) -> CGRect {
        
        guard let indexPath = context.initialIndexPath,
            let attributes: UICollectionViewLayoutAttributes = self.collectionView.layoutAttributesForItem(at: indexPath) else {
            return CGRect.zero
        }
        return self.collectionView.convert(attributes.frame, to: self.collectionView.superview)
    }
    
    func initialView(_ context: TransitionControllerContext, isPresenting: Bool) -> UIView {
        
        let indexPath = context.initialIndexPath!
        let cell: UICollectionViewCell = self.collectionView.cellForItem(at: indexPath)!
        return cell.contentView
    }
    
    func prepareInitialView(_ context: TransitionControllerContext, isPresenting: Bool) {
        guard let indexPath = context.initialIndexPath else { return }

        if !isPresenting && !self.collectionView.indexPathsForVisibleItems.contains(indexPath) {
            self.collectionView.reloadData()
            self.collectionView.scrollToItem(at: indexPath, at: .centeredVertically, animated: false)
            self.collectionView.layoutIfNeeded()
        }
    }
}
