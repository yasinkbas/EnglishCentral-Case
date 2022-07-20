//
//  MapModule.swift
//  MapModule
//
//  Created by Yasin Akbas on 8.07.2022.
//  Copyright © 2022 com.yasinkbas.MapModule. All rights reserved.
//

import UIKit
import DependencyManagerKit
import CommonKit

public class HomeModule {
    public init() { }
}

// MARK: - HomeModuleInterface
extension HomeModule: HomeModuleInterface {
    @MainActor
    public func homeViewController(with navigationController: UINavigationController?) -> UIViewController {
        HomeRouter.createModule(using: navigationController)
    }
}
