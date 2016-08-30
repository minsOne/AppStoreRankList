//
//  RankViewModel.swift
//  TopFreeRankAppStore
//
//  Created by JungMin Ahn on 8/27/16.
//  Copyright © 2016 JungMin Ahn. All rights reserved.
//

import UIKit
import Foundation

struct TableViewCellModel {
    let cellIdentifier: String
    let applyViewModelToCell: (UITableViewCell, Any) -> Void
    let data: Any

    init(cellIdentifier: String, applyViewModelToCell: (UITableViewCell, Any) -> Void, data: Any) {
        self.cellIdentifier = cellIdentifier
        self.applyViewModelToCell = applyViewModelToCell
        self.data = data
    }
}

extension TableViewCellModel {
    func applyViewModelToCell(cell: UITableViewCell) {
        self.applyViewModelToCell(cell, self.data)
    }
}

struct TableViewSectionModel {
    let cells: [TableViewCellModel]

    init(cells: [TableViewCellModel]) {
        self.cells = cells
    }
}

struct TableViewModel {
    let sections: [TableViewSectionModel]

    init(sections: [TableViewSectionModel]) {
        self.sections = sections
    }

    subscript(indexPath: NSIndexPath) -> TableViewCellModel {
        return self.sections[indexPath.section].cells[indexPath.row]
    }
}
