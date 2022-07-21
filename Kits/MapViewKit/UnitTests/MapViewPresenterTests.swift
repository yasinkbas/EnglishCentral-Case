//
//  MapViewPresenterTests.swift
//  MapViewKit
//
//  Created by Yasin Akbas on 19.07.2022.
//  Copyright © 2022 com.yasinkbas.MapViewKit. All rights reserved.
//

@testable import MapViewKit
import XCTest

final class MapViewPresenterTests: XCTestCase {
    var view: MockMapView!
    var presenter: MapViewPresenter!
    
    var locationManager: MockLocationManager!
    
    override func setUp() {
        super.setUp()
        view = .init()
        locationManager = .init()
        presenter = .init(view: view, locationManager: locationManager)
    }
    
    func test_load_InvokesRelatedMethods() {
        presenter.load()
        
        XCTAssertTrue(view.invokedPrepareUI)
        XCTAssertTrue(locationManager.invokedConfigure)
        XCTAssertTrue(locationManager.invokedConfigureParameters?.delegate === presenter)
        XCTAssertTrue(locationManager.invokedStart)
    }
    
    func test_centerUserCurrentLocation_UserLocationNotExist_NotInvokesRelatedMethods() {
        presenter.centerUserCurrentLocation()
        
        XCTAssertFalse(view.invokedCenterUserLocation)
    }
    
    func test_centerUserCurrentLocation_UserLocationExist_CentersUserLocation() {
        presenter.locationManager(.init(latitude: 1, longitude: 2), error: nil)
        
        view.invokedCenterUserLocation = false
        view.invokedCenterUserLocationParameters = nil
        
        presenter.centerUserCurrentLocation()
        
        XCTAssertTrue(view.invokedCenterUserLocation)
        XCTAssertEqual(view.invokedCenterUserLocationParameters?.region.center.longitude, 2)
        XCTAssertEqual(view.invokedCenterUserLocationParameters?.region.center.latitude, 1)
        XCTAssertEqual(view.invokedCenterUserLocationParameters?.region.span.latitudeDelta, 0.018087334733778156)
        XCTAssertEqual(view.invokedCenterUserLocationParameters?.region.span.longitudeDelta, 0.01796902942957538)
    }
    
    func test_locationManager_ErrorExist_ShowsAlert() {
        presenter.locationManager(nil, error: .locationNotObtained)
        
        XCTAssertTrue(view.invokedShowAlert)
        XCTAssertEqual(view.invokedShowAlertParameters?.message, "Your current location could not obtained. Please try again later.")
        XCTAssertFalse(view.invokedCenterUserLocation)
    }
    
    func test_locationManager_CenterValueExist_InvokesRelatedMethods() {
        presenter.locationManager(.init(latitude: 1, longitude: 2), error: nil)
        
        XCTAssertFalse(view.invokedShowAlert)
        XCTAssertTrue(view.invokedCenterUserLocation)
        XCTAssertEqual(view.invokedCenterUserLocationParameters?.region.center.longitude, 2)
        XCTAssertEqual(view.invokedCenterUserLocationParameters?.region.center.latitude, 1)
        XCTAssertEqual(view.invokedCenterUserLocationParameters?.region.span.latitudeDelta, 0.018087334733778156)
        XCTAssertEqual(view.invokedCenterUserLocationParameters?.region.span.longitudeDelta, 0.01796902942957538)
    }
    
    func test_locationManager_IsFirstLoadFalse_NotCentersUserLocation() {
        presenter.locationManager(.init(latitude: 1, longitude: 2), error: nil)
        
        view.invokedCenterUserLocation = false
        view.invokedCenterUserLocationCount = 0
        
        presenter.locationManager(.init(latitude: 1, longitude: 2), error: nil)
        
        XCTAssertFalse(view.invokedCenterUserLocation)
        XCTAssertEqual(view.invokedCenterUserLocationCount, 0)
    }
}
