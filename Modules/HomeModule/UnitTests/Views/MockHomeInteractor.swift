//
//  MockHomeInteractor.swift
//  HomeModuleTests
//
//  Created by Yasin Akbas on 18.07.2022.
//  Copyright © 2022 com.yasinkbas.HomeModule. All rights reserved.
//

import XCTest
@testable import HomeModule
import CommonKit

final class MockHomeInteractor: HomeInteractorInterface {
    var invokedFetchAutoSuggests = false
    var invokedFetchAutoSuggestsCount = 0
    var invokedFetchAutoSuggestsParameters: (at: String, q: String)?
    var invokedFetchAutoSuggestsParametersList = [(at: String, q: String)]()
    var stubbedFetchAutoSuggestsParameters: CommonKit.APIResponse<CommonKit.AutoSuggestResponse>?

    func fetchAutoSuggests(at: String, q: String) async -> CommonKit.APIResponse<CommonKit.AutoSuggestResponse>? {
        invokedFetchAutoSuggests = true
        invokedFetchAutoSuggestsCount += 1
        invokedFetchAutoSuggestsParameters = (at, q)
        invokedFetchAutoSuggestsParametersList.append((at, q))
        return stubbedFetchAutoSuggestsParameters
    }
}
