//
//  MOITunesTopFreeRankViewController+ViewModel.swift
//  TopFreeRankAppStore
//
//  Created by JungMin Ahn on 8/27/16.
//  Copyright © 2016 JungMin Ahn. All rights reserved.
//

import Foundation
import UIKit

func rankViewModelForRankList(appInfoList: [AppInfo]) -> TableViewModel {
    if appInfoList.isEmpty { return TableViewModel(sections: []) }

    let cellModels = appInfoList.map { viewModelForRank($0) }
    let sectionModel = TableViewSectionModel(cells: cellModels)
    return TableViewModel(sections: [sectionModel])
}

func viewModelForRank(rank: AppInfo) -> TableViewCellModel {
    func applyViewModelToRankCell(cell: UITableViewCell, appInfo: Any) {
        guard
            let cell = cell as? MOAppRankListCell,
            let appInfo = appInfo as? AppInfo
            else { return }
        cell.configure(appInfo)
    }

    return TableViewCellModel(cellIdentifier: MOAppRankListCell.cellIdentifier,
                              applyViewModelToCell: applyViewModelToRankCell,
                              data: rank)
}
