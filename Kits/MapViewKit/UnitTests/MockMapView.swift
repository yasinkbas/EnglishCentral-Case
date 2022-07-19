//
//  MockMapView.swift
//  MapViewKit
//
//  Created by Yasin Akbas on 19.07.2022.
//  Copyright © 2022 com.yasinkbas.MapViewKit. All rights reserved.
//

@testable import MapViewKit
import MapKit

final class MockMapView: MapViewInterface {

    var invokedPrepareUI = false
    var invokedPrepareUICount = 0

    func prepareUI() {
        invokedPrepareUI = true
        invokedPrepareUICount += 1
    }

    var invokedCenterUserLocation = false
    var invokedCenterUserLocationCount = 0
    var invokedCenterUserLocationParameters: (region: MKCoordinateRegion, Void)?
    var invokedCenterUserLocationParametersList = [(region: MKCoordinateRegion, Void)]()

    func centerUserLocation(region: MKCoordinateRegion) {
        invokedCenterUserLocation = true
        invokedCenterUserLocationCount += 1
        invokedCenterUserLocationParameters = (region, ())
        invokedCenterUserLocationParametersList.append((region, ()))
    }

    var invokedAddAnnotation = false
    var invokedAddAnnotationCount = 0
    var invokedAddAnnotationParameters: (annotation: MKPointAnnotation, Void)?
    var invokedAddAnnotationParametersList = [(annotation: MKPointAnnotation, Void)]()

    func addAnnotation(_ annotation: MKPointAnnotation) {
        invokedAddAnnotation = true
        invokedAddAnnotationCount += 1
        invokedAddAnnotationParameters = (annotation, ())
        invokedAddAnnotationParametersList.append((annotation, ()))
    }

    var invokedRemoveAllAnnotations = false
    var invokedRemoveAllAnnotationsCount = 0

    func removeAllAnnotations() {
        invokedRemoveAllAnnotations = true
        invokedRemoveAllAnnotationsCount += 1
    }

    var invokedFitAnnotations = false
    var invokedFitAnnotationsCount = 0

    func fitAnnotations() {
        invokedFitAnnotations = true
        invokedFitAnnotationsCount += 1
    }

    var invokedShowAlert = false
    var invokedShowAlertCount = 0
    var invokedShowAlertParameters: (message: String, Void)?
    var invokedShowAlertParametersList = [(message: String, Void)]()

    func showAlert(message: String) {
        invokedShowAlert = true
        invokedShowAlertCount += 1
        invokedShowAlertParameters = (message, ())
        invokedShowAlertParametersList.append((message, ()))
    }
}
