//
//  MOAppRankListCell.swift
//  TopFreeRankAppStore
//
//  Created by JungMin Ahn on 8/27/16.
//  Copyright © 2016 JungMin Ahn. All rights reserved.
//

import UIKit
import Kingfisher

class MOAppRankListCell: UITableViewCell, CellNib {
    @IBOutlet weak var rankLabel: UILabel?
    @IBOutlet weak var appIconImageView: UIImageView?
    @IBOutlet weak var appTitleLabel: UILabel?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.clear()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.clear()
    }

    func clear() {
        self.rankLabel?.text = ""
        self.appIconImageView?.image = nil
        self.appTitleLabel?.text = ""
    }

    func configure(appInfo: AppInfo) {
        self.rankLabel?.text = "\(appInfo.ranking)"
        self.appTitleLabel?.text = "\(appInfo.title)"
        self.appIconImageView?.kf_setImageWithURL(NSURL(string: appInfo.iconImageURLStr))
    }
}
