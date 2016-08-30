//
//  MOITunesTopFreeRankDetailTableViewShim.swift
//  TopFreeRankAppStore
//
//  Created by JungMin Ahn on 8/29/16.
//  Copyright © 2016 JungMin Ahn. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SwiftyJSON

private let kITunesRSSResult = "results"
private let kITunesRSSScreenShotURLs = "screenshotUrls"
private let kITunesRSSArtworkURL = "artworkUrl100"
private let kITunesRSSSupportedDevices = "supportedDevices"
private let kITunesRSSDescription = "description"
private let kITunesRSSTitle = "trackName"
private let kITunesRSSAverageUserRating = "averageUserRating"
private let kITunesRSSUserRatingCount = "userRatingCount"


protocol SelectedScreenShotCellDelegate: class {
    func didSelectScreenShotCell(indexPath: NSIndexPath, screenShotURLStrs: [String])
}

final class MOAppDetailTableViewShim: NSObject {
    private let tableView: UITableView
    private let disposeBag = DisposeBag()
    private let cellTypes: [CellType]
    var appId: String
    var rankDetailViewModel: TableViewModel?
    var screenshotURLStrs: [String] = []
    weak var delegate: SelectedScreenShotCellDelegate?

    init(cellTypes: [CellType], tableView: UITableView, appId: String) {
        self.tableView = tableView
        self.cellTypes = cellTypes
        self.appId = appId

        super.init()

        self.configure()
    }
}

extension MOAppDetailTableViewShim {
    func configure() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.registerNib()
        self.tableView.tableFooterView = UIView()
        self.tableView.estimatedRowHeight = 400.0
        self.tableView.rowHeight = 80
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
}

extension MOAppDetailTableViewShim: UITableViewDelegate, UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.rankDetailViewModel?.sections[section].cells.count ?? 0
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.rankDetailViewModel?.sections.count ?? 0
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let cellViewModel = self.rankDetailViewModel?[indexPath] else { return UITableViewCell() }
        let cell = tableView.dequeueReusableCellWithIdentifier(cellViewModel.cellIdentifier,
                                                               forIndexPath: indexPath) ?? UITableViewCell()
        cell.selectionStyle = .None
        cellViewModel.applyViewModelToCell(cell)
        return cell
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let rowHeight = self.tableView.rowHeight
        guard
            let cellViewModel = self.rankDetailViewModel?[indexPath]
            else { return rowHeight }
        if cellViewModel.cellIdentifier == MOAppDetailDescriptionCell.cellIdentifier {
            return UITableViewAutomaticDimension
        } else if cellViewModel.cellIdentifier == MOAppDetailScreenShotCell.cellIdentifier {
            return 230
        }

        return rowHeight
    }

    func tableView(tableView: UITableView,
                   willDisplayCell cell: UITableViewCell,
                   forRowAtIndexPath indexPath: NSIndexPath) {
        guard
            let cell = cell as? MOAppDetailScreenShotCell
            else { return }
        cell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, indexPath: indexPath)
    }
}

extension MOAppDetailTableViewShim: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return self.screenshotURLStrs.isEmpty ? 0 : 1
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.screenshotURLStrs.count
    }

    func collectionView(collectionView: UICollectionView,
                        cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cellIdentifier = MOAppDetailScreenShotImageCell.cellIdentifier
        guard
            let cell =
            collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath)
                as? MOAppDetailScreenShotImageCell,
            let screenShotURLStr = self.screenshotURLStrs[safe: indexPath.row]
            else {
            return UICollectionViewCell()
        }
        cell.configure(screenShotURLStr)

        return cell
    }

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.delegate?.didSelectScreenShotCell(indexPath, screenShotURLStrs: self.screenshotURLStrs)
    }
}



extension MOAppDetailTableViewShim {
    func requestAppDetailInfo() {
        DefaultITunesAppNetworkRequest.sharedAPI
            .requestAppDetailInfo(self.appId)
            .retry(2)
            .map { rankinfo -> (TableViewModel, [String]) in
                return self.makeAppDetailInfo(rankinfo)
            }
            .subscribeOn(kBackgroundScheduler)
            .observeOn(MainScheduler.instance)
        .subscribe(
            onNext: { [unowned self] (viewModel, screenShotURLStrs) in
                self.rankDetailViewModel = viewModel
                self.screenshotURLStrs = screenShotURLStrs
                self.reloadTableView()
            },
            onError: { (error) in

            },
            onCompleted: nil,
            onDisposed: nil)
        .addDisposableTo(disposeBag)
    }
}

extension MOAppDetailTableViewShim {
    func makeAppDetailInfo(responseInfo: ResponseInfo) -> (TableViewModel, [String]) {
        guard
            let result = responseInfo.info[kITunesRSSResult].array?.first
            else { return (TableViewModel(sections: []), []) }

        let screenshotURLStrs = result.dictionaryValue[kITunesRSSScreenShotURLs]?.arrayValue.map {$0.stringValue} ?? []
        let artworkImageURLStr = result.dictionaryValue[kITunesRSSArtworkURL]?.stringValue ?? ""
        let description = result.dictionaryValue[kITunesRSSDescription]?.stringValue ?? ""
        let supportDevices = result.dictionaryValue[kITunesRSSSupportedDevices]?.arrayValue.map { $0.stringValue } ?? []
        let title = result.dictionaryValue[kITunesRSSTitle]?.stringValue ?? ""
        let averageRating = result.dictionaryValue[kITunesRSSAverageUserRating]?.doubleValue ?? 0.0

        let appDetailInfo = AppDetail(artworkURLStr: artworkImageURLStr,
                                      screenshotURLs: screenshotURLStrs,
                                      supportedDevices: supportDevices,
                                      description: description,
                                      title: title,
                                      averageRating: CGFloat(averageRating))

        let viewModel = makeAppDetailViewModel(appDetailInfo)
        return (viewModel, screenshotURLStrs)
    }
}
