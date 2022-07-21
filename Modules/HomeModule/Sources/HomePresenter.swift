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
import PersistentManagerKit

protocol HomePresenterInterface: AnyObject {
    func viewDidLoad()
    func emptyViewTapped()
    func showMyLocationButtonTapped()
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
final class HomePresenter {
    private weak var view: HomeViewInterface?
    private let router: HomeRouterInterface
    private let interactor: HomeInteractorInterface
    
    private var mapModule: MapViewPresenterInterface?
    private var homeNavigationModule: HomeNavigationViewPresenterInterface?
    private var homeHistoryModule: HomeHistoryPresenterInterface?
    
    var userCurrentLocation: CLLocationCoordinate2D?
    
    private(set) var nearestPlaces: [Place] = []
    private var searchText: String = ""
    
    init(
        view: HomeViewInterface,
        router: HomeRouterInterface,
        interactor: HomeInteractorInterface
    ) {
        self.view = view
        self.router = router
        self.interactor = interactor
    }
    
    func handleUserCurrentLocation() {
        guard let userCurrentLocation = mapModule?.currentLocation else {
            view?.showAlert(message: "Please choose a location from your xcode first")
            return
        }
        self.userCurrentLocation = userCurrentLocation
    }
    
    func convertDistanceToKilometers(distance: Int) -> String {
        guard distance >= 1000 else { return "\(distance)m away"}
        return String(format:"%.1f", Float(distance) / 1000) + "km away"
    }
    
    @discardableResult
    func addAnnotation(for place: Place) -> MKPointAnnotation? {
        guard let latitude = place.position?[safe: Constant.latitudeIndexPosition],
              let longitude = place.position?[safe: Constant.longitudeIndexPosition],
              let title = place.title,
              let categoryTitle = place.categoryTitle,
              let distance = place.distance else { return nil }
        let convertedDistance = convertDistanceToKilometers(distance: distance)
        let annotation = MKPointAnnotation()
        annotation.title = title
        annotation.subtitle = "\(categoryTitle)\n\(convertedDistance)"
        annotation.coordinate = .init(latitude: latitude, longitude: longitude)
        view?.addAnnotation(annotation)
        return annotation
    }
    
    @discardableResult
    func addAnnotation(for annotation: Annotation) -> MKPointAnnotation? {
        guard let latitude = annotation.latitude?.toDouble,
              let longitude = annotation.longitude?.toDouble,
              let title = annotation.title,
              let subtitle = annotation.subtitle else { return nil }
        let annotation = MKPointAnnotation()
        annotation.title = title
        annotation.subtitle = subtitle
        annotation.coordinate = .init(latitude: latitude, longitude: longitude)
        view?.addAnnotation(annotation)
        return annotation
    }
    
    func showNearestPlaces(with places: [Place], threshold: Int) {
        nearestPlaces = Array(places
            .filter { $0.distance != nil }
            .sorted(by: { $0.distance! < $1.distance! })
            .prefix(threshold)
        )
        let annotations = nearestPlaces
            .compactMap { addAnnotation(for: $0) }
            .map { annotation in
                let object = Annotation(context: interactor.mapManagedObjectContext)
                object.title = annotation.title
                object.subtitle = annotation.subtitle
                object.latitude = String(annotation.coordinate.latitude)
                object.longitude = String(annotation.coordinate.longitude)
                return object
        }
        handleUserCurrentLocation()
        guard let latitude = userCurrentLocation?.latitude.toString,
              let longitude = userCurrentLocation?.longitude.toString else { return }
        interactor.saveHistory(searchText: searchText,
                               latitude: latitude,
                               longitude: longitude,
                               annotations: annotations)
    }
    
    func fetchAutoSuggests(at: String, q: String) async {
        guard let places = await interactor.fetchAutoSuggests(at: at, q: q)?.results else {
            view?.hideLoading()
            view?.showAlert(message: "Please check your api key")
            return
        }
        showNearestPlaces(with: places, threshold: Constant.suggestedPlacesCountThreshold)
        view?.hideLoading()
        view?.fitMapAnnotations()
    }
    
    func showSearchHistory() {
        do {
            let searchHistoryItems = try interactor.getHistory()
            homeHistoryModule?.setHistory(historyItems: searchHistoryItems.reversed())
            view?.showHistoryView()
        } catch {
            view?.showAlert(message: error.localizedDescription)
        }
    }
}

// MARK: - HomePresenterInterface
extension HomePresenter: HomePresenterInterface {
    func viewDidLoad() {
        mapModule = view?.prepareMapView()
        homeNavigationModule = view?.prepareNavigationView(delegate: self)
        homeHistoryModule = view?.prepareHistoryView(delegate: self)
        view?.prepareUI()
    }
    
    func emptyViewTapped() {
        view?.hideKeyboard()
        view?.hideHistoryView()
    }
    
    func showMyLocationButtonTapped() {
        mapModule?.centerUserCurrentLocation()
    }
}

// MARK: - HomeNavigationViewPresenterDelegate
extension HomePresenter: HomeNavigationViewPresenterDelegate {
    func searchButtonTapped(searchText: String) {
        handleUserCurrentLocation()
        guard !searchText.isEmpty,
              let userCurrentLocation = userCurrentLocation else { return }
        nearestPlaces.removeAll(keepingCapacity: true)
        view?.removeAllAnnotations()
        view?.hideKeyboard()
        view?.hideHistoryView()
        view?.showLoading()
        self.searchText = searchText
        Task {
            await fetchAutoSuggests(at: "\(userCurrentLocation.latitude),\(userCurrentLocation.longitude)",
                                    q: searchText)
        }
    }
    
    func searchBarShouldBeginEditing() {
        showSearchHistory()
    }
}

// MARK: - HomeHistoryPresenterDelegate
extension HomePresenter: HomeHistoryPresenterDelegate {
    func didSelectRowAt(item: HistoryItem) {
        handleUserCurrentLocation()
        view?.hideHistoryView()
        view?.removeAllAnnotations()
        guard let searchText = item.searchText else { return }
        homeNavigationModule?.updateSearchBarText(searchText)
        item.annotations?
            .compactMap { $0 as? Annotation }
            .forEach { addAnnotation(for: $0) }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            self?.view?.fitMapAnnotations()
        }
    }
}
