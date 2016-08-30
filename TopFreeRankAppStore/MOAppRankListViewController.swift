//
//  MOITunesTopFreeRankViewController.swift
//  TopFreeRankAppStore
//
//  Created by JungMin Ahn on 8/27/16.
//  Copyright © 2016 JungMin Ahn. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

private let kSegueAppDetail = "AppDetailSegue"
private let kRefreshButtonTitle = "refresh"

class StructObject: NSObject {
    let data: Any?
    init(data: Any?) {
        self.data = data
    }
}

struct AppInfo {
    let ranking: Int
    let iconImageURLStr: String
    let summary: String
    let appId: String
    let bundleId: String
    let title: String
}

class MOAppRankListViewController: UIViewController {
    @IBOutlet weak var rankTableView: UITableView!
    @IBOutlet weak var errorLabel: UILabel!
    var tableViewRender: MOAppRankListTableViewShim?
}

extension MOAppRankListViewController {
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
        if let detailVC = destVC as? MOAppDetailViewController,
            let obj = sender as? StructObject,
            let data = obj.data as? AppInfo {
            detailVC.appInfo = data
        }
    }
}

extension MOAppRankListViewController {
    func configure() {
        let rankCell = CellType(nibName: MOAppRankListCell.nibName,
                                cellIdentifier: MOAppRankListCell.cellIdentifier)
        self.tableViewRender = MOAppRankListTableViewShim(cellTypes: [rankCell], tableView: self.rankTableView)
        self.tableViewRender?.delegate = self
        self.tableViewRender?.errorLabel = self.errorLabel
        self.tableViewRender?.rankViewModel = rankViewModelForRankList([])
        self.tableViewRender?.requestRankList()
        let refreshButton = UIBarButtonItem(title: kRefreshButtonTitle,
                                            style: UIBarButtonItemStyle.Plain,
                                            target: self,
                                            action: #selector(refreshList))
        self.navigationItem.rightBarButtonItem = refreshButton
        self.errorLabel.hidden = true
    }
}

extension MOAppRankListViewController: RankTableViewDelegate {
    func didSelectCell(appInfo: AppInfo) {
        print(appInfo)
        self.performSegueWithIdentifier(kSegueAppDetail, sender: StructObject(data: appInfo))
    }

    func layoutIfNeeded() {
        self.view.layoutIfNeeded()
    }
}

extension MOAppRankListViewController {
    func refreshList() {
        self.tableViewRender?.requestRankList()
    }
}
