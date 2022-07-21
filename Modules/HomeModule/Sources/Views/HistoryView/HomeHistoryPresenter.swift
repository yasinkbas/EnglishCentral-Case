//
//  HomeHistoryPresenter.swift
//  HomeModule
//
//  Created by Yasin Akbas on 21.07.2022.
//  Copyright © 2022 com.yasinkbas.HomeModule. All rights reserved.
//

import Foundation
import CommonKit
import PersistentManagerKit

protocol HomeHistoryPresenterDelegate: AnyObject {
    func didSelectRowAt(item: HistoryItem)
}

protocol HomeHistoryPresenterInterface: AnyObject {
    var calculatedHeight: Double { get }
    var tableViewNumberOfSection: Int { get }
    var tableViewHeightForRow: Double { get }
    
    func load()
    func cellTitleFor(index: Int) -> String
    func setHistory(historyItems: [HistoryItem])
    func didSelectRowAt(index: Int)
}

private extension HomeHistoryPresenter {
    enum Constant {
        static let height: Double = 50
    }
}

final class HomeHistoryPresenter {
    private weak var view: HomeHistoryViewInterface?
    private weak var delegate: HomeHistoryPresenterDelegate?
    private var historyItems: [HistoryItem]?
    private let screenHeight: Double
    
    init(
        view: HomeHistoryViewInterface,
        delegate: HomeHistoryPresenterDelegate,
        screenHeight: Double = Screen.height
    ) {
        self.view = view
        self.delegate = delegate
        self.screenHeight = screenHeight
    }
}

// MARK: - HomeHistoryPresenterInterface
extension HomeHistoryPresenter: HomeHistoryPresenterInterface {
    var calculatedHeight: Double {
        let limitedScreenHeight = screenHeight * 2 / 3
        let contentHeight = Double(tableViewNumberOfSection) * tableViewHeightForRow
        return contentHeight > limitedScreenHeight
        ? limitedScreenHeight
        : contentHeight
    }
    
    var tableViewNumberOfSection: Int { historyItems?.count ?? .zero }
    var tableViewHeightForRow: Double { Constant.height }
    
    func load() {
        view?.prepareUI()
    }
    
    func cellTitleFor(index: Int) -> String {
        let item = historyItems?[safe: index]
        var searchText = item?.searchText ?? "Undefined text"
        if let latitude = item?.userLocationLatitude,
           let longitude = item?.userLocationLongitude {
            searchText.append(" in \(latitude):\(longitude)")
        }
        return searchText
    }
    
    func setHistory(historyItems: [HistoryItem]) {
        self.historyItems = historyItems
        view?.reloadTableView()
    }
    
    func didSelectRowAt(index: Int) {
        guard let item = historyItems?[safe: index] else { return }
        delegate?.didSelectRowAt(item: item)
    }
}
