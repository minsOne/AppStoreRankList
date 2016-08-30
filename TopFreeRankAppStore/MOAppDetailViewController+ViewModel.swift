//
//  MOAppDetailViewController+ViewModel.swift
//  TopFreeRankAppStore
//
//  Created by JungMin Ahn on 8/29/16.
//  Copyright © 2016 JungMin Ahn. All rights reserved.
//

import Foundation
import UIKit


func makeAppDetailViewModel(appDetail: AppDetail) -> TableViewModel {
    let titleCellViewModel = viewModelForAppDetailTitle(appDetail)
    let screenshotCellViewModel = viewModelForAppDetailScreenshot(appDetail)
    let descriptionCellViewModel = viewModelForAppDetailDescription(appDetail)
    let viewModels = [titleCellViewModel, screenshotCellViewModel, descriptionCellViewModel]
    let sectionModel = TableViewSectionModel(cells: viewModels)
    return TableViewModel(sections: [sectionModel])
}

func viewModelForAppDetailTitle(appDetail: AppDetail) -> TableViewCellModel {
    func applyViewModelToTitleCell(cell: UITableViewCell, data: Any) {
        guard
            let cell = cell as? MOAppDetailTitleCell,
            let detail = data as? AppDetail
            else { return }
        let artworkImageURL = NSURL(string: detail.artworkURLStr)
        cell.configure(artworkImageURL, title: detail.title, rating: detail.averageRating)
    }
    return TableViewCellModel(cellIdentifier: MOAppDetailTitleCell.cellIdentifier,
                              applyViewModelToCell: applyViewModelToTitleCell,
                              data: appDetail)
}

func viewModelForAppDetailScreenshot(appDetail: AppDetail) -> TableViewCellModel {
    func applyViewModelToScreenshotCell(cell: UITableViewCell, data: Any) {
        guard
            let cell = cell as? MOAppDetailScreenShotCell,
            let detail = data as? AppDetail
            else { return }
        cell.configure(detail.screenshotURLs)
    }
    return TableViewCellModel(cellIdentifier: MOAppDetailScreenShotCell.cellIdentifier,
                              applyViewModelToCell: applyViewModelToScreenshotCell,
                              data: appDetail)
}

func viewModelForAppDetailDescription(appDetail: AppDetail) -> TableViewCellModel {
    func applyViewModelToDescriptionCell(cell: UITableViewCell, data: Any) {
        guard
            let cell = cell as? MOAppDetailDescriptionCell,
            let detail = data as? AppDetail
            else { return }
        cell.configure(detail.description)
    }

    return TableViewCellModel(cellIdentifier: MOAppDetailDescriptionCell.cellIdentifier,
                              applyViewModelToCell: applyViewModelToDescriptionCell,
                              data: appDetail)
}
