//
//  MOAppDetailDescriptionCell.swift
//  TopFreeRankAppStore
//
//  Created by JungMin Ahn on 8/27/16.
//  Copyright © 2016 JungMin Ahn. All rights reserved.
//

import UIKit

class MOAppDetailDescriptionCell: UITableViewCell, CellNib {
    @IBOutlet weak var decriptionLabel: UILabel!
}

extension MOAppDetailDescriptionCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
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
}

extension MOAppDetailDescriptionCell {
    func clear() {
        self.decriptionLabel.text = ""
    }

    func configure(descriptionText: String) {
        self.decriptionLabel.text = descriptionText
        self.decriptionLabel.sizeToFit()
    }
}
