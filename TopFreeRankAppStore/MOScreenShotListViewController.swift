//
//  MOScreenShotListViewController.swift
//  TopFreeRankAppStore
//
//  Created by JungMin Ahn on 8/30/16.
//  Copyright © 2016 JungMin Ahn. All rights reserved.
//

import UIKit
import Kingfisher

class MOScreenShotListViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    var screenShotURLStrs: [String] = []
    var selectedScreenShotImageIdx: Int = 0
    var collectionViewRender: MOScreenShotListCollectionViewShim?
}

extension MOScreenShotListViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.configure()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.collectionViewRender?.reloadData()
        self.collectionViewRender?.scrollToPage(selectedScreenShotImageIdx)
    }
}

extension MOScreenShotListViewController {
    func configure() {
        let screenShotCell = CellType(nibName: MOAppDetailScreenShotImageCell.nibName,
                                      cellIdentifier: MOAppDetailScreenShotImageCell.cellIdentifier)
        self.collectionViewRender = MOScreenShotListCollectionViewShim(cellTypes: [screenShotCell],
                                                                       collectionView: self.collectionView)
        self.collectionViewRender?.screenShotViewModel = screenShotViewModel(screenShotURLStrs)
        self.collectionViewRender?.delegate = self
        self.pageControl.currentPage = 0
        self.pageControl.numberOfPages = screenShotURLStrs.count
    }
}

extension MOScreenShotListViewController: PageControlDelegate {
    func setCurrentPage(page: Int) {
        self.pageControl.currentPage = page
    }
}


private func screenShotViewModel(screenShotURLStrs: [String]) -> CollectionViewModel {
    let cellModels = screenShotURLStrs.map { viewModelForScreenShot($0) }
    let sectionModel = CollectionViewSectionModel(cells: cellModels)
    return CollectionViewModel(sections: [sectionModel])
}

private func viewModelForScreenShot(screenShotURLStr: String) -> CollectionViewCellModel {
    func applyViewModelToScreenShotCell(cell: UICollectionViewCell, urlStr: Any) {
        guard
            let cell = cell as? MOAppDetailScreenShotImageCell,
            let urlStr = urlStr as? String
            else { return }
        cell.screenShotImageView.contentMode = .ScaleAspectFit
        cell.configure(urlStr)
    }

    return CollectionViewCellModel(cellIdentifier: MOAppDetailScreenShotImageCell.cellIdentifier,
                                   applyViewModelToCell: applyViewModelToScreenShotCell,
                                   data: screenShotURLStr)
}
