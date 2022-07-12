//
//  AppRouter.swift
//  EnglishCentral-Case
//
//  Created by Yasin Akbas on 10.07.2022.
//  Copyright © 2022 com.yasinkbas.EnglishCentral-Case. All rights reserved.
//

import UIKit
import DependencyManagerKit

final class AppRouter {
    @Dependency var homeModule: HomeModuleInterface
    
    let window: UIWindow?
    
    init(window: UIWindow?) {
        self.window = window
    }
    
    func initializeRootViewController() {
        let navigationController = UINavigationController()
        let homeViewController = homeModule.homeViewController(with: navigationController)
        navigationController.setViewControllers([homeViewController], animated: false)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}
