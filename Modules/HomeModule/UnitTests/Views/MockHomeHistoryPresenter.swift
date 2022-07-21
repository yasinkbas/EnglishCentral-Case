//
//  MockHomeHistoryPresenter.swift
//  HomeModuleTests
//
//  Created by Yasin Akbas on 21.07.2022.
//  Copyright © 2022 com.yasinkbas.HomeModule. All rights reserved.
//

@testable import HomeModule
import PersistentManagerKit

final class MockHomeHistoryPresenter: HomeHistoryPresenterInterface {

    var invokedCalculatedHeightGetter = false
    var invokedCalculatedHeightGetterCount = 0
    var stubbedCalculatedHeight: Double! = 0

    var calculatedHeight: Double {
        invokedCalculatedHeightGetter = true
        invokedCalculatedHeightGetterCount += 1
        return stubbedCalculatedHeight
    }

    var invokedTableViewNumberOfSectionGetter = false
    var invokedTableViewNumberOfSectionGetterCount = 0
    var stubbedTableViewNumberOfSection: Int! = 0

    var tableViewNumberOfSection: Int {
        invokedTableViewNumberOfSectionGetter = true
        invokedTableViewNumberOfSectionGetterCount += 1
        return stubbedTableViewNumberOfSection
    }

    var invokedTableViewHeightForRowGetter = false
    var invokedTableViewHeightForRowGetterCount = 0
    var stubbedTableViewHeightForRow: Double! = 0

    var tableViewHeightForRow: Double {
        invokedTableViewHeightForRowGetter = true
        invokedTableViewHeightForRowGetterCount += 1
        return stubbedTableViewHeightForRow
    }

    var invokedLoad = false
    var invokedLoadCount = 0

    func load() {
        invokedLoad = true
        invokedLoadCount += 1
    }

    var invokedCellTitleFor = false
    var invokedCellTitleForCount = 0
    var invokedCellTitleForParameters: (index: Int, Void)?
    var invokedCellTitleForParametersList = [(index: Int, Void)]()
    var stubbedCellTitleForResult: String! = ""

    func cellTitleFor(index: Int) -> String {
        invokedCellTitleFor = true
        invokedCellTitleForCount += 1
        invokedCellTitleForParameters = (index, ())
        invokedCellTitleForParametersList.append((index, ()))
        return stubbedCellTitleForResult
    }

    var invokedSetHistory = false
    var invokedSetHistoryCount = 0
    var invokedSetHistoryParameters: (historyItems: [HistoryItem], Void)?
    var invokedSetHistoryParametersList = [(historyItems: [HistoryItem], Void)]()

    func setHistory(historyItems: [HistoryItem]) {
        invokedSetHistory = true
        invokedSetHistoryCount += 1
        invokedSetHistoryParameters = (historyItems, ())
        invokedSetHistoryParametersList.append((historyItems, ()))
    }

    var invokedDidSelectRowAt = false
    var invokedDidSelectRowAtCount = 0
    var invokedDidSelectRowAtParameters: (index: Int, Void)?
    var invokedDidSelectRowAtParametersList = [(index: Int, Void)]()

    func didSelectRowAt(index: Int) {
        invokedDidSelectRowAt = true
        invokedDidSelectRowAtCount += 1
        invokedDidSelectRowAtParameters = (index, ())
        invokedDidSelectRowAtParametersList.append((index, ()))
    }
}
