//
//  MOAppDetailScreenShotCell.swift
//  TopFreeRankAppStore
//
//  Created by JungMin Ahn on 8/27/16.
//  Copyright © 2016 JungMin Ahn. All rights reserved.
//

import UIKit

class MOAppDetailScreenShotCell: UITableViewCell, CellNib {
    @IBOutlet weak var collectionView: UICollectionView!
    var screenShotURLs: [String] = []
}

extension MOAppDetailScreenShotCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        let nib = UINib(nibName: MOAppDetailScreenShotImageCell.nibName, bundle: nil)
        let cellIdentifier = MOAppDetailScreenShotImageCell.cellIdentifier
        self.collectionView.registerNib(nib, forCellWithReuseIdentifier: cellIdentifier)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.clear()
    }
}

extension MOAppDetailScreenShotCell {
    func clear() {
        self.screenShotURLs = []
    }

    func configure(screenShotURLStrs: [String]) {
        self.screenShotURLs = screenShotURLStrs
    }

    func setCollectionViewDataSourceDelegate(
        dataSourceDelegate delegate: protocol<UICollectionViewDelegate,UICollectionViewDataSource>,
                           indexPath: NSIndexPath) {
        self.collectionView.dataSource = delegate
        self.collectionView.delegate = delegate
        self.collectionView.reloadData()
    }
}
