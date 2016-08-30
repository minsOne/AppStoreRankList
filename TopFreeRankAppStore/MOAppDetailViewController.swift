//
//  MOAppDetailViewController.swift
//  TopFreeRankAppStore
//
//  Created by JungMin Ahn on 8/27/16.
//  Copyright © 2016 JungMin Ahn. All rights reserved.
//

import UIKit

private let kSegueScreenShotList = "ScreenShotListSegue"

struct AppDetail {
    let artworkURLStr: String
    let screenshotURLs: [String]
    let supportedDevices: [String]
    let description: String
    let title: String
    let averageRating: CGFloat
}

class MOAppDetailViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var appInfo: AppInfo!
    var tableViewRender: MOAppDetailTableViewShim?
}

extension MOAppDetailViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destVC = segue.destinationViewController
        if let screenShotVC = destVC as? MOScreenShotListViewController,
            let obj = sender as? StructObject,
            let data = obj.data as? ([String], Int) {
            screenShotVC.screenShotURLStrs = data.0
            screenShotVC.selectedScreenShotImageIdx = data.1
        }
    }
}

extension MOAppDetailViewController {
    func configure() {
        let appTitleCell = CellType(nibName: MOAppDetailTitleCell.nibName,
                                    cellIdentifier: MOAppDetailTitleCell.cellIdentifier)
        let screenshotCell = CellType(nibName: MOAppDetailScreenShotCell.nibName,
                                      cellIdentifier: MOAppDetailScreenShotCell.cellIdentifier)
        let descriptionCell = CellType(nibName: MOAppDetailDescriptionCell.nibName,
                                       cellIdentifier: MOAppDetailDescriptionCell.cellIdentifier)
        self.tableViewRender = MOAppDetailTableViewShim(cellTypes: [appTitleCell, screenshotCell, descriptionCell],
                                                       tableView: self.tableView,
                                                       appId: self.appInfo.appId)
        self.tableViewRender?.rankDetailViewModel = TableViewModel(sections: [])
        self.tableViewRender?.delegate = self
        self.tableViewRender?.requestAppDetailInfo()
    }
}

extension MOAppDetailViewController: SelectedScreenShotCellDelegate {
    func didSelectScreenShotCell(indexPath: NSIndexPath, screenShotURLStrs: [String]) {
        let structObj = StructObject(data: (screenShotURLStrs, indexPath.row))
        self.performSegueWithIdentifier(kSegueScreenShotList, sender: structObj)
    }
}
