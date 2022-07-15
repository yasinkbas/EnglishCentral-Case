//
//  HomePresenter.swift
//  HomeModule
//
//  Created by Yasin Akbas on 8.07.2022.
//  Copyright © 2022 com.yasinkbas.HomeModule. All rights reserved.
//

import Foundation
import CommonKit
import DependencyManagerKit
import MapViewKit
import CoreLocation

protocol HomePresenterInterface: AnyObject {
    var navigationViewDelegate: HomeNavigationViewPresenterDelegate { get }
    
    func viewDidLoad()
}

final class HomePresenter: NSObject {   
    private weak var view: HomeViewInterface?
    private let router: HomeRouterInterface
    private let interactor: HomeInteractorInterface
    private var places: APIResponse<AutoSuggestResponse>?
    private var mapModule: MapViewPresenterInterface?
    private var homeNavigationModule: HomeNavigationViewPresenterInterface?
    
    init(
        view: HomeViewInterface,
        router: HomeRouterInterface,
        interactor: HomeInteractorInterface
    ) {
        self.view = view
        self.router = router
        self.interactor = interactor
    }
    
    func fetchAutoSuggests(at: String, q: String) {
        Task {
            places = await interactor.fetchAutoSuggests(at: at, q: q)
        }
    }
}

// MARK: - HomePresenterInterface
extension HomePresenter: HomePresenterInterface {
    var navigationViewDelegate: HomeNavigationViewPresenterDelegate { self }
    
    func viewDidLoad() {
        mapModule = view?.prepareMapView()
        homeNavigationModule = view?.prepareNavigationView()
        view?.prepareUI()
    }
}

// MARK: - HomeNavigationViewPresenterDelegate
extension HomePresenter: HomeNavigationViewPresenterDelegate {
    func searchButtonTapped(searchText: String) {
        guard !searchText.isEmpty else { return }
        // TODO: make request
        fetchAutoSuggests(at: "40.74917,-73.98529", q: searchText)
    }
}
