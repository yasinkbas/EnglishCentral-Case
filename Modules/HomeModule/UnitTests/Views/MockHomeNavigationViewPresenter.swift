//
//  MockHomeNavigationViewPresenter.swift
//  HomeModuleTests
//
//  Created by Yasin Akbas on 19.07.2022.
//  Copyright © 2022 com.yasinkbas.HomeModule. All rights reserved.
//

import Foundation
@testable import HomeModule

final class MockHomeNavigationViewPresenter: HomeNavigationViewPresenterInterface {

    var invokedLoad = false
    var invokedLoadCount = 0

    func load() {
        invokedLoad = true
        invokedLoadCount += 1
    }

    var invokedSearchButtonTapped = false
    var invokedSearchButtonTappedCount = 0

    func searchButtonTapped() {
        invokedSearchButtonTapped = true
        invokedSearchButtonTappedCount += 1
    }

    var invokedSearchBar = false
    var invokedSearchBarCount = 0
    var invokedSearchBarParameters: (searchText: String, Void)?
    var invokedSearchBarParametersList = [(searchText: String, Void)]()

    func searchBar(textDidChange searchText: String) {
        invokedSearchBar = true
        invokedSearchBarCount += 1
        invokedSearchBarParameters = (searchText, ())
        invokedSearchBarParametersList.append((searchText, ()))
    }
}
