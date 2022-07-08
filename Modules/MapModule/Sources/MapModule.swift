//
//  MapModule.swift
//  MapModule
//
//  Created by Yasin Akbas on 8.07.2022.
//  Copyright © 2022 com.yasinkbas.MapModule. All rights reserved.
//

import UIKit

// MARK: MapModuleInterface
public protocol MapModuleInterface {
    func mapViewController() -> UIViewController
}

// MARK: MapModule
public class MapModule: MapModuleInterface {
    public func mapViewController() -> UIViewController {
        UIViewController()
    }
}
