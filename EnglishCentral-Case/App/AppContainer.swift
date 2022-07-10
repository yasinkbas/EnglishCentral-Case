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
        configureNavigationController()
        configureService()
        configureUILab()
    }
    
    private func configureNavigationController() {
//        UINavigationBar.appearance().isTranslucent = false
    }
    
    private func configureService() {
        struct Response: Decodable {
            let placesApiKey: String
        }
        let response: Response = try! PropertyListHandler().read(fileName: "APIKeys")
        NetworkConfigs.register(placesApiKey: response.placesApiKey)
//        trendService = Service(client: NLClient(baseURL: URL(string: "https://api.trendyol.com/")!), window: window, dispatchMain: DispatchQueue.main)
    }
    
    private func configureUILab() {
        UILab.Settings.debugMonitoringType = .verbose
    }
}
