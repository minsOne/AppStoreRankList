//
//  MOScreenShotListCollectionViewShim.swift
//  AppStoreRank
//
//  Created by JungMin Ahn on 8/30/16.
//  Copyright © 2016 JungMin Ahn. All rights reserved.
//

import UIKit

struct CollectionViewCellModel {
    let cellIdentifier: String
    let applyViewModelToCell: (UICollectionViewCell, Any) -> Void
    let data: Any
}

extension CollectionViewCellModel {
    func applyViewModelToCell(cell: UICollectionViewCell) {
        self.applyViewModelToCell(cell, self.data)
    }
}

struct CollectionViewSectionModel {
    let cells: [CollectionViewCellModel]
}

struct CollectionViewModel {
    let sections: [CollectionViewSectionModel]

    subscript(indexPath: NSIndexPath) -> CollectionViewCellModel {
        return self.sections[indexPath.section].cells[indexPath.row]
    }
}

protocol PageControlDelegate: class {
    func setCurrentPage(page: Int)
}

final class MOScreenShotListCollectionViewShim: NSObject {
    let collectionView: UICollectionView
    let cellTypes: [CellType]
    var screenShotViewModel: CollectionViewModel?
    weak var delegate: PageControlDelegate?

    init(cellTypes: [CellType], collectionView: UICollectionView) {
        self.collectionView = collectionView
        self.cellTypes = cellTypes

        super.init()

        self.configure()
    }
}

extension MOScreenShotListCollectionViewShim {
    func configure() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.pagingEnabled = true
        self.registerNib()
    }

    func registerNib() {
        self.cellTypes.forEach {
            let nib = UINib(nibName: $0.nibName, bundle: nil)
            self.collectionView.registerNib(nib, forCellWithReuseIdentifier: $0.cellIdentifier)
        }
    }

    func reloadData() {
        self.collectionView.reloadData()
    }

    func scrollToPage(page: Int) {
        let position = CGPoint(x: self.collectionView.bounds.width * CGFloat(page),
                               y: self.collectionView.contentOffset.y)
        self.collectionView.setContentOffset(position, animated: false)
    }
}

extension MOScreenShotListCollectionViewShim: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return self.screenShotViewModel?.sections.count ?? 0
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.screenShotViewModel?.sections[section].cells.count ?? 0
    }

    func collectionView(collectionView: UICollectionView,
                        cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        guard
            let cellViewModel = self.screenShotViewModel?[indexPath]
            else { return UICollectionViewCell() }

        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellViewModel.cellIdentifier,
                                                                         forIndexPath: indexPath)
        cellViewModel.applyViewModelToCell(cell)
        return cell
    }
}

extension MOScreenShotListCollectionViewShim: UICollectionViewDelegateFlowLayout {
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return makeScreenShotImageSize(collectionView.bounds.size)
    }
}

extension MOScreenShotListCollectionViewShim: UIScrollViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let page: Int = Int(scrollView.contentOffset.x / scrollView.frame.size.width + 0.5)
        DFT_TRACE_PRINT(output: scrollView.contentOffset.x, scrollView.frame.size.width, page)
        self.delegate?.setCurrentPage(page)
    }
}

private func makeScreenShotImageSize(viewSize: CGSize) -> CGSize {
    return viewSize
}
