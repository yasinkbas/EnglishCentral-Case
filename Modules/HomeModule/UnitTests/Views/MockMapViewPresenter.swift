//
//  MockMapViewPresenter.swift
//  HomeModuleTests
//
//  Created by Yasin Akbas on 19.07.2022.
//  Copyright © 2022 com.yasinkbas.HomeModule. All rights reserved.
//

@testable import HomeModule
import MapViewKit
import CoreLocation

final class MockMapViewPresenter: MapViewPresenterInterface {

    var invokedCurrentLocationGetter = false
    var invokedCurrentLocationGetterCount = 0
    var stubbedCurrentLocation: CLLocationCoordinate2D!

    var currentLocation: CLLocationCoordinate2D? {
        invokedCurrentLocationGetter = true
        invokedCurrentLocationGetterCount += 1
        return stubbedCurrentLocation
    }

    var invokedLoad = false
    var invokedLoadCount = 0

    func load() {
        invokedLoad = true
        invokedLoadCount += 1
    }

    var invokedCenterUserCurrentLocation = false
    var invokedCenterUserCurrentLocationCount = 0

    func centerUserCurrentLocation() {
        invokedCenterUserCurrentLocation = true
        invokedCenterUserCurrentLocationCount += 1
    }
}
