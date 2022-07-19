//
//  MockHomeNavigationView.swift
//  HomeModuleTests
//
//  Created by Yasin Akbas on 18.07.2022.
//  Copyright © 2022 com.yasinkbas.HomeModule. All rights reserved.
//

import Foundation
@testable import HomeModule

final class MockHomeNavigationView: HomeNavigationViewInterface {

    var invokedPrepareUI = false
    var invokedPrepareUICount = 0

    func prepareUI() {
        invokedPrepareUI = true
        invokedPrepareUICount += 1
    }
}
