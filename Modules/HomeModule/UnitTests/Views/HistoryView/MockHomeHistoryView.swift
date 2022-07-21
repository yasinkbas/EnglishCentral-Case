//
//  MockHomeHistoryView.swift
//  HomeModuleTests
//
//  Created by Yasin Akbas on 21.07.2022.
//  Copyright © 2022 com.yasinkbas.HomeModule. All rights reserved.
//

@testable import HomeModule
import Foundation

final class MockHomeHistoryView: HomeHistoryViewInterface {

    var invokedViewHeightGetter = false
    var invokedViewHeightGetterCount = 0
    var stubbedViewHeight: Double! = 0

    var viewHeight: Double {
        invokedViewHeightGetter = true
        invokedViewHeightGetterCount += 1
        return stubbedViewHeight
    }

    var invokedPrepareUI = false
    var invokedPrepareUICount = 0

    func prepareUI() {
        invokedPrepareUI = true
        invokedPrepareUICount += 1
    }

    var invokedReloadTableView = false
    var invokedReloadTableViewCount = 0

    func reloadTableView() {
        invokedReloadTableView = true
        invokedReloadTableViewCount += 1
    }
}
