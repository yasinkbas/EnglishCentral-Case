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

protocol HomeInteractorInterface: AnyObject {
    func fetchAutoSuggests(at: String, q: String) async -> APIResponse<AutoSuggestResponse>?
}

final class HomeInteractor: HomeInteractorInterface {
    func fetchAutoSuggests(at: String, q: String) async -> APIResponse<AutoSuggestResponse>? {
        await PlacesAPI().autoSuggest(at: at, q: q).startAsync()
    }
}
