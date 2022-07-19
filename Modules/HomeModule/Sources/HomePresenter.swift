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
        static let latitudeIndexPosition: Int = 0
        static let longitudeIndexPosition: Int = 1
    }
}

typealias Place = AutoSuggestResponse

@MainActor
final class HomePresenter: NSObject {   
    private weak var view: HomeViewInterface?
    private let router: HomeRouterInterface
    private let interactor: HomeInteractorInterface
    private var distanceOfPlaces: [Place: Int] = [:]
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
    
    func addAnnotation(for place: Place) {
        guard let latitude = place.position?[safe: Constant.latitudeIndexPosition],
              let longitude = place.position?[safe: Constant.longitudeIndexPosition] else { return }
        let annotation = MKPointAnnotation()
        annotation.title = place.title
        annotation.subtitle = place.categoryTitle
        annotation.coordinate = .init(latitude: latitude, longitude: longitude)
        view?.addAnnotation(annotation)
    }
    
    func showNearestPlaces(with places: [Place], threshold: Int) async {
        do {
            distanceOfPlaces = try await sortPlacesByDistance(places: places)
        } catch {
            guard let message = (error as? LocationManager.LocationManagerError)?.description else { return }
            view?.showAlert(message: message)
        }
        
        let nearestPlaces = Array(distanceOfPlaces.keys).sorted(by: { distanceOfPlaces[$0]! < distanceOfPlaces[$1]! })
        let placesCountThreshold = nearestPlaces.count > threshold
        ? threshold
        : nearestPlaces.count
        Array((nearestPlaces.prefix(placesCountThreshold))).forEach { place in
            addAnnotation(for: place)
        }
    }
    
    func sortPlacesByDistance(places: [Place]) async throws -> [Place: Int] {
        try await withThrowingTaskGroup(of: (place: Place, distance: Int).self,
                                        returning: [Place: Int].self, body: { taskGroup in
            for place in places {
                guard let latitude = place.position?[safe: Constant.latitudeIndexPosition],
                      let longitude = place.position?[safe: Constant.longitudeIndexPosition],
                      let mapModule else { continue }
                taskGroup.addTask {
                    let distance = try await mapModule.getDistance(latitude: latitude, longitude: longitude)
                    return (place, distance)
                }
            }
            
            var result = [Place : Int]()
            for try await taskResult in taskGroup {
                result[taskResult.place] = taskResult.distance
            }
            return result
        })
    }
    
    func fetchAutoSuggests(at: String, q: String) async {
        guard let places = await interactor.fetchAutoSuggests(at: at, q: q)?.results else { return }
        await showNearestPlaces(with: places, threshold: Constant.suggestedPlacesCountThreshold)
        view?.hideLoading()
        view?.fitMapAnnotations()
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
        Task { await fetchAutoSuggests(at: "\(userCurrentLocation.latitude),\(userCurrentLocation.longitude)", q: searchText) }
    }
}
