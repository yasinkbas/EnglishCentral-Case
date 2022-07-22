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
import PersistentManagerKit
import CoreData

enum DummyError: LocalizedError {
    case failed
    
    var errorDescription: String? { "Dummy error description" }
}

@MainActor
final class HomePresenterTests: XCTestCase {
    var presenter: HomePresenter!
    var view: MockHomeViewController!
    var interactor: MockHomeInteractor!
    var router: MockHomeRouter!
    
    var mapModule: MockMapViewPresenter?
    var navigationModule: MockHomeNavigationViewPresenter?
    var historyModule: MockHomeHistoryPresenter?
    
    var objectContext: NSManagedObjectContext {
        // TODO: Must have mocked persistent manager
        PersistentManager.managedObjectContext(container: .map)
    }
    
    override func setUp() {
        super.setUp()
        view = .init()
        interactor = .init()
        router = .init()
        presenter = .init(view: view, router: router, interactor: interactor)
        interactor.stubbedMapManagedObjectContext = objectContext
    }
    
    func test_handleUserCurrentLocation_UserLocationIsExist_SetsUserLocation() {
        prepareModules()
        
        mapModule!.stubbedCurrentLocation = .init(latitude: 1, longitude: 2)
        presenter.handleUserCurrentLocation()
        
        XCTAssertEqual(presenter.userCurrentLocation?.latitude, 1)
        XCTAssertEqual(presenter.userCurrentLocation?.longitude, 2)
    }
    
    func test_handleUserCurrentLocation_UserLocationNotExist_ShowsAlert() {
        prepareModules()
        
        mapModule!.stubbedCurrentLocation = nil
        presenter.handleUserCurrentLocation()
        
        XCTAssertNil(presenter.userCurrentLocation)
        XCTAssertTrue(view.invokedShowAlert)
        XCTAssertEqual(view.invokedShowAlertParameters?.message, "Please choose a location from your xcode first")
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
        XCTAssertTrue(view.invokedShowAlert)
        XCTAssertEqual(view.invokedShowAlertParameters?.message, "Please check your api key")
        
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
    
    func test_showSearchHistory_InvokesRelatedMethods() {
        prepareModules()
        
        let dummyHistoryItem1 = HistoryItem(context: objectContext)
        let dummyHistoryItem2 = HistoryItem(context: objectContext)
        dummyHistoryItem1.searchText = "text1"
        dummyHistoryItem2.searchText = "text2"
        interactor.stubbedGetHistoryResult = [dummyHistoryItem1, dummyHistoryItem2].reversed()

        presenter.showSearchHistory()
        
        XCTAssertTrue(interactor.invokedGetHistory)
        XCTAssertTrue(historyModule!.invokedSetHistory)
        XCTAssertEqual(historyModule!.invokedSetHistoryParameters?.historyItems[0].searchText, "text1")
        XCTAssertEqual(historyModule!.invokedSetHistoryParameters?.historyItems[1].searchText, "text2")
        XCTAssertTrue(view.invokedShowHistoryView)
    }
    
    func test_showSearchHistory_ThrowsError_ShowsAlert() {
        prepareModules()
        interactor.stubbedGetHistoryError = DummyError.failed
        
        presenter.showSearchHistory()
        
        XCTAssertTrue(interactor.invokedGetHistory)
        XCTAssertFalse(historyModule!.invokedSetHistory)
        XCTAssertFalse(view.invokedShowHistoryView)
        XCTAssertTrue(view.invokedShowAlert)
        XCTAssertEqual(view.invokedShowAlertParameters?.message, "Dummy error description")
    }
    
    func test_viewDidLoad_InvokesRelatedMethods() {
        prepareModules()
        
        XCTAssertTrue(view.invokedPrepareMapView)
        XCTAssertTrue(view.invokedPrepareNavigationView)
        XCTAssertTrue(view.invokedPrepareHistoryView)
        XCTAssertTrue(view.invokedPrepareUI)
    }
    
    func test_emptyViewTapped_InvokesRelatedMethods() {
        presenter.emptyViewTapped()
        
        XCTAssertTrue(view.invokedHideKeyboard)
        XCTAssertTrue(view.invokedHideHistoryView)
    }
    
    func test_showMyLocationButtonTapped_CentersUserCurrentLocation() {
        prepareModules()
        
        presenter.showMyLocationButtonTapped()
        
        XCTAssertTrue(mapModule!.invokedCenterUserCurrentLocation)
    }
    
    func test_searchButtonTapped_UserCurrentLocationIsNilSearchTextExist_DoesNotInvokesRelatedMethods() {
        presenter.searchButtonTapped(searchText: "Bread")
        
        XCTAssertFalse(view.invokedRemoveAllAnnotations)
        XCTAssertFalse(view.invokedHideKeyboard)
        XCTAssertFalse(view.invokedHideHistoryView)
        XCTAssertFalse(view.invokedShowLoading)
    }
    
    func test_searchButtonTapped_UserCurrentLocationExistSearchTextEmpty_DoesNotInvokesRelatedMethods() {
        prepareModules()
        
        presenter.searchButtonTapped(searchText: "")
        
        XCTAssertFalse(view.invokedRemoveAllAnnotations)
        XCTAssertFalse(view.invokedHideKeyboard)
        XCTAssertFalse(view.invokedHideHistoryView)
        XCTAssertFalse(view.invokedShowLoading)
    }
    
    func test_searchButtonTapped_UserCurrentLocationExistSearchTextExist_DoesNotInvokesRelatedMethods() {
        prepareModules()
        mapModule!.stubbedCurrentLocation = .init(latitude: 1, longitude: 2)
        presenter.handleUserCurrentLocation()
        
        presenter.searchButtonTapped(searchText: "Bread")
        
        XCTAssertTrue(view.invokedRemoveAllAnnotations)
        XCTAssertTrue(view.invokedHideKeyboard)
        XCTAssertTrue(view.invokedHideHistoryView)
        XCTAssertTrue(view.invokedShowLoading)
    }
    
    func test_searchBarShouldBeginEditing_ShowsSearchHistory() {
        presenter.searchBarShouldBeginEditing()
        
        XCTAssertTrue(view.invokedShowHistoryView)
    }
    
    func test_didSelectRowAt_SearchTextNotExist_InvokesRelatedMethods() {
        prepareModules()
        mapModule?.stubbedCurrentLocation = .init(latitude: 1, longitude: 2)
        
        presenter.didSelectRowAt(item: .init(context: objectContext))
        
        XCTAssertTrue(mapModule!.invokedCurrentLocationGetter)
        XCTAssertTrue(view.invokedHideHistoryView)
        XCTAssertTrue(view.invokedRemoveAllAnnotations)
        XCTAssertFalse(navigationModule!.invokedUpdateSearchBarText)
    }
    
    func test_didSelectRowAt_SearchTextExist_InvokesRelatedMethods() {
        prepareModules()
        mapModule?.stubbedCurrentLocation = .init(latitude: 1, longitude: 2)
        
        let dummyHistoryItem = HistoryItem(context: objectContext)
        dummyHistoryItem.searchText = "bread"
        presenter.didSelectRowAt(item: dummyHistoryItem)
        
        XCTAssertTrue(mapModule!.invokedCurrentLocationGetter)
        XCTAssertTrue(view.invokedHideHistoryView)
        XCTAssertTrue(view.invokedRemoveAllAnnotations)
        XCTAssertTrue(navigationModule!.invokedUpdateSearchBarText)
        XCTAssertEqual(navigationModule!.invokedUpdateSearchBarTextParameters!.text, "bread")
    }
    
    // MARK: - Helpers
    private func prepareModules() {
        mapModule = MockMapViewPresenter()
        navigationModule = MockHomeNavigationViewPresenter()
        historyModule = MockHomeHistoryPresenter()
        view.stubbedPrepareMapViewResult = mapModule
        view.stubbedPrepareNavigationViewResult = navigationModule
        view.stubbedPrepareHistoryViewResult = historyModule
        
        presenter.viewDidLoad()
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
