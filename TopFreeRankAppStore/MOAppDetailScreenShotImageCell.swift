//
//  MOAppDetailScreenShotImageCell.swift
//  TopFreeRankAppStore
//
//  Created by JungMin Ahn on 8/29/16.
//  Copyright © 2016 JungMin Ahn. All rights reserved.
//

import UIKit
import Kingfisher

class MOAppDetailScreenShotImageCell: UICollectionViewCell, CellNib {
    @IBOutlet weak var screenShotImageView: UIImageView!
}

extension MOAppDetailScreenShotImageCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.screenShotImageView.image = nil
    }
}

extension MOAppDetailScreenShotImageCell {
    func configure(screenshotURLStr: String) {
        self.screenShotImageView.kf_setImageWithURL(NSURL(string: screenshotURLStr))
    }
}
