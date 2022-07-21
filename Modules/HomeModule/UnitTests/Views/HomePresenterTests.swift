//
//  HomePresenterTests.swift
//  HomeModuleTests
//
//  Created by Yasin Akbas on 18.07.2022.
//  Copyright © 2022 com.yasinkbas.HomeModule. All rights reserved.
//

import XCTest
@testable import HomeModule
import CommonKit

@MainActor
final class HomePresenterTests: XCTestCase {
    var presenter: HomePresenter!
    var view: MockHomeViewController!
    var interactor: MockHomeInteractor!
    var router: MockHomeRouter!
    
    override func setUp() {
        super.setUp()
        view = .init()
        interactor = .init()
        router = .init()
        presenter = .init(view: view, router: router, interactor: interactor)
    }
    
    func test_convertDistanceToKilometers_DistanceLowerThanThousands_ReturnsCorrectValueAsMeters() {
        let value = presenter.convertDistanceToKilometers(distance: 501)
        
        XCTAssertEqual(value, "501m away")
    }
    
    func test_convertDistanceToKilometers_DistanceHigherThanThousands_ReturnsCorrectValueAsKilometers() {
        let value = presenter.convertDistanceToKilometers(distance: 1200)
        
        XCTAssertEqual(value, "1.2km away")
    }
    
    func test_addAnnotation_LatitudeAndLongitudeAreNotExist_DoesNotAddAnnotation() {
        presenter.addAnnotation(for: emptyAutoSuggestResponse)
        
        XCTAssertFalse(view.invokedAddAnnotation)
    }
    
    func test_addAnnotation_LatitudeOrLongitudeIsNotExist_DoesNotAddAnnotation() {
        presenter.addAnnotation(for: latitudeExistAutoSuggestResponse)
        
        XCTAssertFalse(view.invokedAddAnnotation)
    }
    
    func test_addAnnotation_LatitudeAndLongitudeAreExist_AddsAnnotation() {
        presenter.addAnnotation(for: filledAutoSuggestResponse)
        
        XCTAssertTrue(view.invokedAddAnnotation)
        XCTAssertEqual(view.invokedAddAnnotationParameters?.annotation.title, "Dardenia (Dardenia Fish & Bread)")
        XCTAssertEqual(view.invokedAddAnnotationParameters?.annotation.subtitle, "Restaurant\n19.1km away")
        XCTAssertEqual(view.invokedAddAnnotationParameters?.annotation.coordinate.latitude, 41.02703)
        XCTAssertEqual(view.invokedAddAnnotationParameters?.annotation.coordinate.longitude, 29.1256)
    }
    
    func test_showNearestPlaces_PlacesAreMoreThanThreshold_ShowsLimitedPlaces() {
        presenter.showNearestPlaces(with: autoSuggestAPIResponse.results, threshold: 10)

        XCTAssertEqual(presenter.nearestPlaces.count, 10)
        XCTAssertEqual(presenter.nearestPlaces.first?.distance, 2689)
        XCTAssertEqual(presenter.nearestPlaces.last?.distance, 19110)
        
        XCTAssertTrue(view.invokedAddAnnotation)
        XCTAssertEqual(view.invokedAddAnnotationCount, 10)
        XCTAssertEqual(view.invokedAddAnnotationParametersList.first?.annotation.title, "Mybread")
        XCTAssertEqual(view.invokedAddAnnotationParametersList.first?.annotation.subtitle, "Restaurant\n2.7km away")
        XCTAssertEqual(view.invokedAddAnnotationParametersList.first?.annotation.coordinate.latitude, 41.01113)
        XCTAssertEqual(view.invokedAddAnnotationParametersList.first?.annotation.coordinate.longitude, 28.90758)
    }
    
    func test_showNearestPlaces_PlacesAreLessThanThreshold_ShowsAllPlaces() {
        presenter.showNearestPlaces(with: autoSuggestAPIResponse.results, threshold: 20)

        XCTAssertEqual(presenter.nearestPlaces.count, 14)
        XCTAssertEqual(presenter.nearestPlaces.first?.distance, 2689)
        XCTAssertEqual(presenter.nearestPlaces.last?.distance, 14965607)
        
        XCTAssertTrue(view.invokedAddAnnotation)
        XCTAssertEqual(view.invokedAddAnnotationCount, 14)
        XCTAssertEqual(view.invokedAddAnnotationParametersList.first?.annotation.title, "Mybread")
        XCTAssertEqual(view.invokedAddAnnotationParametersList.first?.annotation.subtitle, "Restaurant\n2.7km away")
        XCTAssertEqual(view.invokedAddAnnotationParametersList.first?.annotation.coordinate.latitude, 41.01113)
        XCTAssertEqual(view.invokedAddAnnotationParametersList.first?.annotation.coordinate.longitude, 28.90758)
    }
    
    func test_fetchAutoSuggests_PlacesIsNotExist_DoesNotInvokesRelatedMethods() async {
        interactor.stubbedFetchAutoSuggestsParameters = nil
        
        await presenter.fetchAutoSuggests(at: "1,2", q: "Bread")
        
        XCTAssertTrue(interactor.invokedFetchAutoSuggests)
        XCTAssertEqual(interactor.invokedFetchAutoSuggestsParameters?.at, "1,2")
        XCTAssertEqual(interactor.invokedFetchAutoSuggestsParameters?.q, "Bread")
        XCTAssertTrue(view.invokedHideLoading)
        
        XCTAssertEqual(presenter.nearestPlaces.count, 0)
        XCTAssertFalse(view.invokedAddAnnotation)
        XCTAssertFalse(view.invokedFitMapAnnotations)
    }
    
    func test_fetchAutoSuggests_PlacesIsExist_DoesNotInvokesRelatedMethods() async {
        interactor.stubbedFetchAutoSuggestsParameters = autoSuggestAPIResponse
        
        await presenter.fetchAutoSuggests(at: "1,2", q: "Bread")
        
        XCTAssertTrue(interactor.invokedFetchAutoSuggests)
        XCTAssertEqual(interactor.invokedFetchAutoSuggestsParameters?.at, "1,2")
        XCTAssertEqual(interactor.invokedFetchAutoSuggestsParameters?.q, "Bread")
        
        XCTAssertEqual(presenter.nearestPlaces.count, 10)
        XCTAssertEqual(presenter.nearestPlaces.first?.distance, 2689)
        XCTAssertEqual(presenter.nearestPlaces.last?.distance, 19110)
        
        XCTAssertTrue(view.invokedAddAnnotation)
        XCTAssertEqual(view.invokedAddAnnotationCount, 10)
        XCTAssertEqual(view.invokedAddAnnotationParametersList.first?.annotation.title, "Mybread")
        XCTAssertEqual(view.invokedAddAnnotationParametersList.first?.annotation.subtitle, "Restaurant\n2.7km away")
        XCTAssertEqual(view.invokedAddAnnotationParametersList.first?.annotation.coordinate.latitude, 41.01113)
        XCTAssertEqual(view.invokedAddAnnotationParametersList.first?.annotation.coordinate.longitude, 28.90758)
        
        XCTAssertTrue(view.invokedHideLoading)
        XCTAssertTrue(view.invokedFitMapAnnotations)
    }
    
    func test_viewDidLoad_InvokesRelatedMethods() {
        let mapModule = MockMapViewPresenter()
        let homeNavigationViewPresenter = MockHomeNavigationViewPresenter()
        
        view.stubbedPrepareMapViewResult = mapModule
        view.stubbedPrepareNavigationViewResult = homeNavigationViewPresenter
        
        presenter.viewDidLoad()
        
        XCTAssertTrue(view.invokedPrepareMapView)
        XCTAssertTrue(view.invokedPrepareNavigationView)
        XCTAssertTrue(view.invokedPrepareUI)
    }
    
    func test_searchButtonTapped_MapModuleIsNilSearchTextExist_InvokesRelatedMethods() {
        presenter.searchButtonTapped(searchText: "Bread")
        
        XCTAssertTrue(view.invokedRemoveAllAnnotations)
        XCTAssertTrue(view.invokedHideKeyboard)
        XCTAssertTrue(view.invokedShowLoading)
    }
}

extension HomePresenterTests {
    var bundle: Bundle { .init(for: Self.self) }
    
    var autoSuggestAPIResponse: APIResponse<AutoSuggestResponse> {
        JSONParser.decode(
            for: APIResponse<AutoSuggestResponse>.self,
            fileName: "AutoSuggestResponse",
            bundle: bundle
        )
    }
    
    var filledAutoSuggestResponse: AutoSuggestResponse {
        autoSuggestAPIResponse.results[0]
    }
    
    var emptyAutoSuggestResponse: AutoSuggestResponse {
        autoSuggestAPIResponse.results[1]
    }
    
    var latitudeExistAutoSuggestResponse: AutoSuggestResponse {
        autoSuggestAPIResponse.results[2]
    }
}
