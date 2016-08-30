//
//  TopFreeRankNetworkRequest.swift
//  TopFreeRankAppStore
//
//  Created by JungMin Ahn on 8/27/16.
//  Copyright © 2016 JungMin Ahn. All rights reserved.
//

import Foundation
import RxSwift
import SwiftyJSON
import Alamofire
import HTTPStatusCodes

enum iTunesRSS {
    case topfreeRank
    case topfreeRankDetail(String)

    var url: String {
        switch self {
        case .topfreeRank:
            let urlStr = "https://itunes.apple.com/kr/rss/topfreeapplications/limit=50/genre=6015/json"
            return urlStr
        case .topfreeRankDetail(let appId):
            let urlStr = "https://itunes.apple.com/lookup?id=\(appId)&country=kr"
            return urlStr
        }
    }
}

enum AvailableStatus {
    case True
    case False(NSError)
}

struct ResponseInfo {
    var info: JSON
}

protocol ITunesAppRankNetworkRequest {
    func requestTopFreeRank() -> Observable<ResponseInfo>
    func requestAppDetailInfo(appId: String) -> Observable<ResponseInfo>
}

class DefaultITunesAppNetworkRequest: ITunesAppRankNetworkRequest {
    static let sharedAPI = DefaultITunesAppNetworkRequest()
    private init() {}

    func requestTopFreeRank() -> Observable<ResponseInfo> {
        return Observable.create { observer -> Disposable in
            Manager.sharedInstance
                .request(Method.GET, iTunesRSS.topfreeRank.url)
                .response() { (request, response, data, error) in
                    if let error = error {
                        observer.onError(error)
                        return
                    }

                    if let data = data {
                        let rankInfo = ResponseInfo(info: JSON(data: data))
                        observer.onNext(rankInfo)
                    }
                    observer.onCompleted()
                }
            return NopDisposable.instance
        }
    }

    func requestAppDetailInfo(appId: String) -> Observable<ResponseInfo> {
        return Observable.create { observer -> Disposable in
            Manager.sharedInstance
                .request(Method.GET, iTunesRSS.topfreeRankDetail(appId).url)
                .response() { (request, response, data, error) in
                    if let error = error {
                        observer.onError(error)
                        return
                    }
                    if let data = data {
                        let info = ResponseInfo(info: JSON(data: data))
                        observer.onNext(info)
                    }
                    observer.onCompleted()
            }
            return NopDisposable.instance
        }
    }
}
