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
import CoreData
import PersistentManagerKit

final class MockHomeInteractor: HomeInteractorInterface {

    var invokedMapManagedObjectContextGetter = false
    var invokedMapManagedObjectContextGetterCount = 0
    var stubbedMapManagedObjectContext: NSManagedObjectContext!

    var mapManagedObjectContext: NSManagedObjectContext {
        invokedMapManagedObjectContextGetter = true
        invokedMapManagedObjectContextGetterCount += 1
        return stubbedMapManagedObjectContext
    }

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

    var invokedGetHistory = false
    var invokedGetHistoryCount = 0
    var stubbedGetHistoryError: Error?
    var stubbedGetHistoryResult: [HistoryItem]! = []

    func getHistory() throws -> [HistoryItem] {
        invokedGetHistory = true
        invokedGetHistoryCount += 1
        if let error = stubbedGetHistoryError {
            throw error
        }
        return stubbedGetHistoryResult
    }

    var invokedSaveHistory = false
    var invokedSaveHistoryCount = 0
    var invokedSaveHistoryParameters: (searchText: String, latitude: String, longitude: String, annotations: [Annotation])?
    var invokedSaveHistoryParametersList = [(searchText: String, latitude: String, longitude: String, annotations: [Annotation])]()

    func saveHistory(searchText: String, latitude: String, longitude: String, annotations: [Annotation]) {
        invokedSaveHistory = true
        invokedSaveHistoryCount += 1
        invokedSaveHistoryParameters = (searchText, latitude, longitude, annotations)
        invokedSaveHistoryParametersList.append((searchText, latitude, longitude, annotations))
    }
}
