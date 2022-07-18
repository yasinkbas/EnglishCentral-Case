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
import MapKit
import CoreLocation

protocol HomePresenterInterface: AnyObject {
    var navigationViewDelegate: HomeNavigationViewPresenterDelegate { get }
    
    func viewDidLoad()
}

extension HomePresenter {
    enum Constant {
        static let suggestedPlacesCountThreshold: Int = 10
    }
}

final class HomePresenter: NSObject {   
    private weak var view: HomeViewInterface?
    private let router: HomeRouterInterface
    private let interactor: HomeInteractorInterface
    private var distanceOfPlaces: [AutoSuggestResponse: Int] = [:]
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
    
    private func sortPlacesByDistance(places: [AutoSuggestResponse]) async throws -> [AutoSuggestResponse: Int] {
        try await withThrowingTaskGroup(of: (AutoSuggestResponse, Int).self, returning: [AutoSuggestResponse: Int].self, body: { taskGroup in
            for place in places {
                guard let latitude = place.position?[safe: 0],
                      let longitude = place.position?[safe: 1],
                      let mapModule else { continue }
                taskGroup.addTask {
                    let distance = try await mapModule.getDistance(latitude: latitude, longitude: longitude)
                    print("-->place: \(place.title) distance:\(distance)")
                    return (place, distance)
                }
            }
            
            var result = [AutoSuggestResponse : Int]()
            for try await taskResult in taskGroup {
                result[taskResult.0] = taskResult.1
            }
            return result
        })
    }
    
    func fetchAutoSuggests(at: String, q: String) {
        Task {
            guard let places = await interactor.fetchAutoSuggests(at: at, q: q)?.results else { return }
            do {
                distanceOfPlaces = try await sortPlacesByDistance(places: places)
            } catch {
                guard let message = (error as? LocationManager.LocationManagerError)?.description else { return }
                view?.showAlert(message: message)
            }
            
            let nearestPlaces = Array(self.distanceOfPlaces.keys).sorted(by: { self.distanceOfPlaces[$0]! < self.distanceOfPlaces[$1]! })
            let count = nearestPlaces.count > 10
            ? Constant.suggestedPlacesCountThreshold
            : nearestPlaces.count
            Array((nearestPlaces.prefix(count))).forEach { place in
                guard let latitude = place.position?[safe: 0],
                      let longitude = place.position?[safe: 1] else { return }
                let annotation = MKPointAnnotation()
                annotation.title = place.title
                annotation.subtitle = place.categoryTitle
                annotation.coordinate = .init(latitude: latitude, longitude: longitude)
                self.view?.addAnnotation(annotation)
            }
            DispatchQueue.main.async {
                self.view?.hideLoading()
                self.view?.fitMapAnnotations()
            }
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
        distanceOfPlaces.removeAll(keepingCapacity: true)
        view?.removeAllAnnotations()
        view?.hideKeyboard()
        view?.showLoading()
        guard let userCurrentLocation = mapModule?.currentLocation,
              !searchText.isEmpty else { return }
        fetchAutoSuggests(at: "\(userCurrentLocation.latitude),\(userCurrentLocation.longitude)", q: searchText)
    }
}
