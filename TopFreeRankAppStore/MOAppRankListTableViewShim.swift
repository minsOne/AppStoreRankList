//
//  TableViewShim.swift
//  TopFreeRankAppStore
//
//  Created by JungMin Ahn on 8/27/16.
//  Copyright © 2016 JungMin Ahn. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SwiftyJSON

private let kITunesRSSFeed = "feed"
private let kITunesRSSEntry = "entry"
private let kITunesRSSIconImage = "im:image"
private let kITunesRSSSummary = "summary"
private let kITunesRSSLabel = "label"
private let kITunesRSSTitle = "title"
private let kITunesRSSId = "id"
private let kITunesRSSAttributes = "attributes"
private let kITunesRSSAppId = "im:id"
private let kITunesRSSBundleId = "im:bundleId"

struct CellType {
    let nibName: String
    let cellIdentifier: String
}

protocol RankTableViewDelegate {
    func didSelectCell(appInfo: AppInfo)
    func layoutIfNeeded()
}

final class MOAppRankListTableViewShim: NSObject {
    let tableView: UITableView
    var errorLabel: UILabel?
    let cellTypes: [CellType]
    var rankViewModel: TableViewModel?
    let disposeBag = DisposeBag()
    var delegate: RankTableViewDelegate?

    init(cellTypes: [CellType], tableView: UITableView) {
        self.tableView = tableView
        self.cellTypes = cellTypes

        super.init()

        self.configure()
    }
}

extension MOAppRankListTableViewShim {
    func configure() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.registerNib()
    }

    func registerNib() {
        self.cellTypes.forEach {
            let nib = UINib(nibName: $0.nibName, bundle: nil)
            self.tableView.registerNib(nib, forCellReuseIdentifier: $0.cellIdentifier)
        }
    }

    func reloadTableView() {
        self.tableView.reloadData()
    }

    func hideErrorMessage() {
        self.tableView.hidden = false
        self.errorLabel?.hidden = true
    }

    func showErrorMessage(msg: String) {
        self.tableView.hidden = true
        self.errorLabel?.hidden = false
        self.errorLabel?.text = msg
        self.errorLabel?.sizeToFit()
        self.delegate?.layoutIfNeeded()
    }
}

extension MOAppRankListTableViewShim: UITableViewDelegate, UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.rankViewModel?.sections[section].cells.count ?? 0
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.rankViewModel?.sections.count ?? 0
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let cellViewModel = self.rankViewModel?[indexPath] else { return UITableViewCell() }
        let cell = tableView.dequeueReusableCellWithIdentifier(cellViewModel.cellIdentifier,
                                                               forIndexPath: indexPath) ?? UITableViewCell()
        cell.selectionStyle = .None
        cellViewModel.applyViewModelToCell(cell)
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        guard
            let delegate = self.delegate,
            let data = self.rankViewModel?[indexPath].data as? AppInfo
            else { return }
        delegate.didSelectCell(data)
    }
}

extension MOAppRankListTableViewShim {
    func requestRankList() {
        DefaultITunesAppNetworkRequest.sharedAPI
            .requestTopFreeRank()
            .retry(2)
            .map { rankInfo -> TableViewModel in
                return self.makeRankList(rankInfo)
            }
            .subscribeOn(kBackgroundScheduler)
            .observeOn(MainScheduler.instance)
            .subscribe(
                onNext: { [unowned self] (viewModel) in
                    self.rankViewModel = viewModel
                    self.tableView.reloadData()
                    self.hideErrorMessage()
                },
                onError: { (error) in
                    self.showErrorMessage((error as NSError).localizedDescription)
                },
                onCompleted: nil,
                onDisposed: nil)
            .addDisposableTo(disposeBag)
    }
}

extension MOAppRankListTableViewShim {
    func makeRankList(responseInfo: ResponseInfo) -> TableViewModel {
        guard
            let list = responseInfo.info[kITunesRSSFeed].dictionary?[kITunesRSSEntry]?.arrayValue
            else { return rankViewModelForRankList([]) }

        let rankList = list.enumerate().map { (idx, info) -> AppInfo in
            let title = info.dictionaryValue[kITunesRSSTitle]?.dictionaryValue[kITunesRSSLabel]?.stringValue ?? ""
            let imageURLStr =
                info.dictionaryValue[kITunesRSSIconImage]?.arrayValue.last?
                    .dictionaryValue[kITunesRSSLabel]?.stringValue ?? ""
            let summary = info.dictionaryValue[kITunesRSSSummary]?.dictionaryValue[kITunesRSSLabel]?.stringValue ?? ""
            let appId =
                info.dictionaryValue[kITunesRSSId]?.dictionaryValue[kITunesRSSAttributes]?
                    .dictionaryValue[kITunesRSSAppId]?.stringValue ?? ""
            let bundleId =
                info.dictionaryValue[kITunesRSSId]?.dictionaryValue[kITunesRSSAttributes]?
                    .dictionaryValue[kITunesRSSBundleId]?.stringValue ?? ""
            let rank = AppInfo(ranking: idx+1,
                iconImageURLStr: imageURLStr,
                summary: summary,
                appId: appId,
                bundleId: bundleId,
                title: title)
            return rank
        }

        let viewModel = rankViewModelForRankList(rankList)
        return viewModel
    }
}
