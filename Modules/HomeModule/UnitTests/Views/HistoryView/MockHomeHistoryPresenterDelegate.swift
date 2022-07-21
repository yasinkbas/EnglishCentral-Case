//
//  MockHomeHistoryPresenterDelegate.swift
//  HomeModuleTests
//
//  Created by Yasin Akbas on 21.07.2022.
//  Copyright © 2022 com.yasinkbas.HomeModule. All rights reserved.
//

@testable import HomeModule
import PersistentManagerKit

final class MockHomeHistoryPresenterDelegate: HomeHistoryPresenterDelegate {

    var invokedDidSelectRowAt = false
    var invokedDidSelectRowAtCount = 0
    var invokedDidSelectRowAtParameters: (item: HistoryItem, Void)?
    var invokedDidSelectRowAtParametersList = [(item: HistoryItem, Void)]()

    func didSelectRowAt(item: HistoryItem) {
        invokedDidSelectRowAt = true
        invokedDidSelectRowAtCount += 1
        invokedDidSelectRowAtParameters = (item, ())
        invokedDidSelectRowAtParametersList.append((item, ()))
    }
}
