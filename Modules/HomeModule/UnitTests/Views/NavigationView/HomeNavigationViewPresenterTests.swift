//
//  HomeNavigationViewPresenterTests.swift
//  HomeModule
//
//  Created by Yasin Akbas on 18.07.2022.
//  Copyright © 2022 com.yasinkbas.HomeModule. All rights reserved.
//

import XCTest
@testable import HomeModule

final class HomeNavigationViewPresenterTests: XCTestCase {
    var presenter: HomeNavigationViewPresenter!
    var view: MockHomeNavigationView!
    var delegate: MockHomeNavigationViewPresenterDelegate!
    
    override func setUp() {
        super.setUp()
        view = .init()
        delegate = .init()
        presenter = HomeNavigationViewPresenter(view: view, delegate: delegate)
    }
    
    func test_load_InvokesRequiredMethods() {
        presenter.load()
        
        XCTAssertTrue(view.invokedPrepareUI)
    }
    
    func test_searchButtonTapped_SearchTextIsEmpty_InvokesDelegateSearchButtonTappedMethod() {
        presenter.searchButtonTapped()
        
        XCTAssertTrue(delegate.invokedSearchButtonTapped)
        XCTAssertEqual(delegate.invokedSearchButtonTappedParameters?.searchText, "")
    }
    
    func test_searchButtonTapped_searchBar_SearchTextIsFilled_InvokesDelegateSearchButtonTappedMethodAndUpdatesSearchText() {
        presenter.searchBar(textDidChange: "Bread")
        
        presenter.searchButtonTapped()
        
        XCTAssertTrue(delegate.invokedSearchButtonTapped)
        XCTAssertEqual(delegate.invokedSearchButtonTappedParameters?.searchText, "Bread")
    }
}
