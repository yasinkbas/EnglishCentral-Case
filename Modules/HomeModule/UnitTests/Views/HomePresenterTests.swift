//
//  HomePresenterTests.swift
//  HomeModuleTests
//
//  Created by Yasin Akbas on 18.07.2022.
//  Copyright © 2022 com.yasinkbas.HomeModule. All rights reserved.
//

import XCTest
@testable import HomeModule

final class HomePresenterTests: XCTestCase {
    var presenter: HomePresenter!
    var view: MockHomeViewController!
    var interactor: MockHomeInteractor!
    var router: MockHomeRouter!
    
    override func setUp() {
        super.setUp()
        view = .init()
        interactor = .init()
        router = .init()
        presenter = .init(view: view, router: router, interactor: interactor)
    }
    
    func test_fetchAutoSuggests_InvokesInteractorFetchAutoSuggestsMethod() async {
        XCTAssertFalse(interactor.invokedFetchAutoSuggests)
        
        await presenter.fetchAutoSuggests(at: "1,2", q: "bread")
        
        XCTAssertTrue(interactor.invokedFetchAutoSuggests)
    }
}
