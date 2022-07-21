//
//  MockHomeNavigationViewPresenterDelegate.swift
//  HomeModuleTests
//
//  Created by Yasin Akbas on 18.07.2022.
//  Copyright © 2022 com.yasinkbas.HomeModule. All rights reserved.
//

import Foundation
@testable import HomeModule

final class MockHomeNavigationViewPresenterDelegate: HomeNavigationViewPresenterDelegate {

    var invokedSearchButtonTapped = false
    var invokedSearchButtonTappedCount = 0
    var invokedSearchButtonTappedParameters: (searchText: String, Void)?
    var invokedSearchButtonTappedParametersList = [(searchText: String, Void)]()

    func searchButtonTapped(searchText: String) {
        invokedSearchButtonTapped = true
        invokedSearchButtonTappedCount += 1
        invokedSearchButtonTappedParameters = (searchText, ())
        invokedSearchButtonTappedParametersList.append((searchText, ()))
    }

    var invokedSearchBarShouldBeginEditing = false
    var invokedSearchBarShouldBeginEditingCount = 0

    func searchBarShouldBeginEditing() {
        invokedSearchBarShouldBeginEditing = true
        invokedSearchBarShouldBeginEditingCount += 1
    }
}
