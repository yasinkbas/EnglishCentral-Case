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
    public func homeViewController(with navigationController: UINavigationController?, arguments: HomePresenterArguments) -> UIViewController {
        HomeRouter.createModule(using: navigationController, arguments: arguments)
    }
}
