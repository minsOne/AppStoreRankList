//
//  MOAppDetailTitleCell.swift
//  TopFreeRankAppStore
//
//  Created by JungMin Ahn on 8/27/16.
//  Copyright © 2016 JungMin Ahn. All rights reserved.
//

import UIKit
import Kingfisher
import HCSStarRatingView

class MOAppDetailTitleCell: UITableViewCell, CellNib {
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingView: HCSStarRatingView!
}

extension MOAppDetailTitleCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.ratingView.userInteractionEnabled = false
        self.ratingView.allowsHalfStars = true
        self.ratingView.tintColor = UIColor.orangeColor()
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

extension MOAppDetailTitleCell {
    func clear() {
        self.iconImageView.image = nil
        self.titleLabel.text = ""
        self.ratingView.value = 0.0
    }

    func configure(imageURL: NSURL?, title: String, rating: CGFloat) {
        self.iconImageView.kf_setImageWithURL(imageURL)
        self.titleLabel.text = title
        self.ratingView.value = rating
    }
}
