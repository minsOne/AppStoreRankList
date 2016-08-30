//
//  Extension.swift
//  TopFreeRankAppStore
//
//  Created by JungMin Ahn on 8/27/16.
//  Copyright © 2016 JungMin Ahn. All rights reserved.
//

import UIKit
import Foundation
import RxSwift

protocol CellNib {}
extension CellNib where Self: UITableViewCell {
    static var nibName: String { return String(self) }
    static var cellIdentifier: String { return "\(String(self))" + "Identifier" }
}

extension CellNib where Self: UICollectionViewCell {
    static var nibName: String { return String(self) }
    static var cellIdentifier: String { return "\(String(self))" + "Identifier" }
}

extension Array {
    subscript (safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }
}

// MARK: RxSwift
let kBackgroundScheduler = ConcurrentDispatchQueueScheduler(globalConcurrentQueueQOS: .Background)

// MARK: Debug
func DFT_TRACE(filename: String = #file, line: Int = #line, funcname: String = #function) {
    #if DEBUG
        print("\(filename)[\(funcname)][Line \(line)]")
    #endif
}

func DFT_TRACE_PRINT(filename: String = #file, line: Int = #line, funcname: String = #function, output: Any...) {
    #if DEBUG
        let now = NSDate()
        print("[\(now.description)][\(filename)][\(funcname)][Line \(line)] \(output)")
    #endif
}
