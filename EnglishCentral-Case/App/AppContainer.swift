//
//  AppContainer.swift
//  EnglishCentral-Case
//
//  Created by Yasin Akbas on 10.07.2022.
//  Copyright © 2022 com.yasinkbas.EnglishCentral-Case. All rights reserved.
//

import UIKit
import NetworkKit
import PersistentManagerKit
import CommonKit
import UILab
import NLab

final class AppContainer {
    let router: AppRouter
    let window: UIWindow?
    
    init(window: UIWindow?) {
        self.window = window
        router = AppRouter(window: window)
        configureNetworkService()
        configureUILab()
        forceToDarkMode()
        
        DependencyHandler().registerDependencies()
    }
    
    private func configureNetworkService() {
        struct Response: Decodable {
            let placesApiKey: String
        }
        let response: Response = try! PropertyListParser.read(fileName: "APIKeys")
        NetworkConfigs.register(placesApiKey: response.placesApiKey)
    }
    
    private func configureUILab() {
        UILab.Settings.debugMonitoringType = .verbose
    }
    
    private func forceToDarkMode() {
        window?.overrideUserInterfaceStyle = .dark
    }
}
