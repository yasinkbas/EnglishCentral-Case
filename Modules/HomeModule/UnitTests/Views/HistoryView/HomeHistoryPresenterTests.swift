//
//  HomeHistoryPresenterTests.swift
//  HomeModuleTests
//
//  Created by Yasin Akbas on 21.07.2022.
//  Copyright © 2022 com.yasinkbas.HomeModule. All rights reserved.
//

@testable import HomeModule
import XCTest
import PersistentManagerKit
import CoreData

extension HomeHistoryPresenterTests {
    enum Dummies {
        static func historyItems(for count: Int, context: NSManagedObjectContext) -> [HistoryItem] {
            (0..<count).map { _ in
                let item = HistoryItem(context: context)
                item.searchText = "search"
                return item
            }
        }
    }
}
final class HomeHistoryPresenterTests: XCTestCase {
    var presenter: HomeHistoryPresenter!
    var view: MockHomeHistoryView!
    var delegate: MockHomeHistoryPresenterDelegate!
    
    var objectContext: NSManagedObjectContext {
        // TODO: Must have mocked persistent manager
        PersistentManager.managedObjectContext(container: .map)
    }
    
    override func setUp() {
        super.setUp()
        reCreate(screenHeight: 500)
    }
    
    func reCreate(screenHeight: Double) {
        view = .init()
        delegate = .init()
        presenter = .init(view: view, delegate: delegate, screenHeight: screenHeight)
    }
    
    func test_calculatedHeight_ContentHeightHigherThanLimitedScreenHeight_ReturnsLimitedScreenHeight() {
        reCreate(screenHeight: 500)
        presenter.setHistory(historyItems: Dummies.historyItems(for: 10, context: objectContext)) // 50 * 10
        
        XCTAssertEqual(presenter.calculatedHeight, 500 * 2 / 3)
    }
    
    func test_calculatedHeight_ContentHeightLowerThanLimitedScreenHeight_ReturnsContentHeight() {
        reCreate(screenHeight: 1000)
        presenter.setHistory(historyItems: Dummies.historyItems(for: 10, context: objectContext)) // 50 * 10
        
        XCTAssertEqual(presenter.calculatedHeight, 500.0)
    }
    
    func test_tableViewNumberOfSection_HistoryItemsExist_ReturnsCorrectValue() {
        presenter.setHistory(historyItems: Dummies.historyItems(for: 3, context: objectContext))
        
        XCTAssertEqual(presenter.tableViewNumberOfSection, 3)
    }
    
    func test_tableViewNumberOfSection_HistoryItemsNotExist_ReturnsZero() {
        XCTAssertEqual(presenter.tableViewNumberOfSection, 0)
    }
    
    func test_tableViewHeightForRow_ReturnsCorrectValue() {
        XCTAssertEqual(presenter.tableViewHeightForRow, 50)
    }
    
    func test_load_InvokesRelatedMethods() {
        presenter.load()
        
        XCTAssertTrue(view.invokedPrepareUI)
    }
    
    func test_cellTitleFor_latitudeAndLongitudeExist_ReturnsCorrectValue() {
        let item = Dummies.historyItems(for: 1, context: objectContext).first
        item?.userLocationLatitude = "1"
        item?.userLocationLongitude = "2"
        
        presenter.setHistory(historyItems: [item!])
        
        XCTAssertEqual(presenter.cellTitleFor(index: 0), "search in 1:2")
    }
    
    func test_cellTitleFor_latitudeAndLongitudeNotExist_ReturnsCorrectValue() {
        presenter.setHistory(historyItems: Dummies.historyItems(for: 1, context: objectContext))
        
        XCTAssertEqual(presenter.cellTitleFor(index: 0), "search")
    }
    
    func test_setHistory_InvokesRelatedMethods() {
        presenter.setHistory(historyItems: Dummies.historyItems(for: 2, context: objectContext))
        
        XCTAssertTrue(view.invokedReloadTableView)
    }
    
    func test_didSelectRowAt_ItemExist_InvokesDelegateDidSelectRowAtMethod() {
        presenter.setHistory(historyItems: Dummies.historyItems(for: 2, context: objectContext))
        
        presenter.didSelectRowAt(index: 1)
        
        XCTAssertTrue(delegate.invokedDidSelectRowAt)
        XCTAssertEqual(delegate.invokedDidSelectRowAtParameters?.item.searchText, "search")
    }
    
    func test_didSelectRowAt_ItemNotExist_DoesNotInvokeDelegateDidSelectRowAtMethod() {
        presenter.setHistory(historyItems: Dummies.historyItems(for: 1, context: objectContext))
        
        presenter.didSelectRowAt(index: 1)
        
        XCTAssertFalse(delegate.invokedDidSelectRowAt)
    }
}
