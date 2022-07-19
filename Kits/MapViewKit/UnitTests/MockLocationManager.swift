//
//  MockLocationManager.swift
//  MapViewKit
//
//  Created by Yasin Akbas on 19.07.2022.
//  Copyright © 2022 com.yasinkbas.MapViewKit. All rights reserved.
//

@testable import MapViewKit

final class MockLocationManager: LocationManagerInterface {

    var invokedStart = false
    var invokedStartCount = 0

    func start() {
        invokedStart = true
        invokedStartCount += 1
    }

    var invokedConfigure = false
    var invokedConfigureCount = 0
    var invokedConfigureParameters: (delegate: LocationManagerDelegate, Void)?
    var invokedConfigureParametersList = [(delegate: LocationManagerDelegate, Void)]()

    func configure(with delegate: LocationManagerDelegate) {
        invokedConfigure = true
        invokedConfigureCount += 1
        invokedConfigureParameters = (delegate, ())
        invokedConfigureParametersList.append((delegate, ()))
    }
}
