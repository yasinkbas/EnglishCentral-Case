//
//  AppContainer.swift
//  EnglishCentral-Case
//
//  Created by Yasin Akbas on 10.07.2022.
//  Copyright © 2022 com.yasinkbas.EnglishCentral-Case. All rights reserved.
//

import UIKit
import UILab
import NetworkKit
import NLab

final class AppContainer {
    let router: AppRouter
    let window: UIWindow?
    
    init(window: UIWindow?) {
        self.window = window
        router = AppRouter(window: window)
        configureService()
        configureUILab()
        forceToDarkMode()
        
        DependencyHandler().registerDependencies()
    }
    
    private func configureService() {
        struct Response: Decodable {
            let placesApiKey: String
        }
        let response: Response = try! PropertyListHandler().read(fileName: "APIKeys")
        NetworkConfigs.register(placesApiKey: response.placesApiKey)
    }
    
    private func configureUILab() {
        UILab.Settings.debugMonitoringType = .verbose
    }
    
    private func forceToDarkMode() {
        if #available(iOS 13.0, *) {
            window?.overrideUserInterfaceStyle = .dark
        }
    }
}
