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

    var invokedUpdateSearchBarText = false
    var invokedUpdateSearchBarTextCount = 0
    var invokedUpdateSearchBarTextParameters: (text: String, Void)?
    var invokedUpdateSearchBarTextParametersList = [(text: String, Void)]()

    func updateSearchBarText(_ text: String) {
        invokedUpdateSearchBarText = true
        invokedUpdateSearchBarTextCount += 1
        invokedUpdateSearchBarTextParameters = (text, ())
        invokedUpdateSearchBarTextParametersList.append((text, ()))
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

    var invokedSearchBarShouldBeginEditing = false
    var invokedSearchBarShouldBeginEditingCount = 0

    func searchBarShouldBeginEditing() {
        invokedSearchBarShouldBeginEditing = true
        invokedSearchBarShouldBeginEditingCount += 1
    }
}
