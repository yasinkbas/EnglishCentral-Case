//
//  MapViewPresenter.swift
//  MapViewKit
//
//  Created by Yasin Akbas on 12.07.2022.
//  Copyright © 2022 com.yasinkbas.MapViewKit. All rights reserved.
//

import Foundation

public protocol MapViewPresenterInterface: AnyObject {
    func load()
}

public class MapViewPresenter {
    private weak var view: MapViewViewInterface?
    private let locationManager: LocationManagerInterface

    public init(view: MapViewViewInterface,
                locationManager: LocationManagerInterface = LocationManager()) {
        self.view = view
        self.locationManager = locationManager
    }
}

// MARK: - MapViewPresenterInterface
extension MapViewPresenter: MapViewPresenterInterface {
    public func load() {
        view?.prepareUI()
        locationManager.start()
    }
}
