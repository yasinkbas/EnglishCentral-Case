//
//  HomeInteractor.swift
//  HomeModule
//
//  Created by Yasin Akbas on 8.07.2022.
//  Copyright © 2022 com.yasinkbas.HomeModule. All rights reserved.
//

import Foundation
import CommonKit
import NetworkKit
import CoreData
import PersistentManagerKit

protocol HomeInteractorInterface: AnyObject {
    var mapManagedObjectContext: NSManagedObjectContext { get }
    func fetchAutoSuggests(at: String, q: String) async -> APIResponse<AutoSuggestResponse>?
    func getHistory() throws -> [HistoryItem]
    func saveHistory(searchText: String, latitude: String, longitude: String, annotations: [Annotation])
}

final class HomeInteractor: HomeInteractorInterface {
    var mapManagedObjectContext: NSManagedObjectContext { PersistentManager.managedObjectContext(container: .map) }
    
    func fetchAutoSuggests(at: String, q: String) async -> APIResponse<AutoSuggestResponse>? {
        await PlacesAPI().autoSuggest(at: at, q: q).startAsync()
    }
    
    func getHistory() throws -> [HistoryItem] {
        try mapManagedObjectContext.fetch(HistoryItem.fetchRequest())
    }
    
    func saveHistory(searchText: String, latitude: String, longitude: String, annotations: [Annotation]) {
        let historyItem = HistoryItem(context: mapManagedObjectContext)
        historyItem.searchText = searchText
        historyItem.userLocationLatitude = latitude
        historyItem.userLocationLongitude = longitude
        annotations.forEach { historyItem.addToAnnotations($0) }
        PersistentManager.saveContext(container: .map)
    }
}
