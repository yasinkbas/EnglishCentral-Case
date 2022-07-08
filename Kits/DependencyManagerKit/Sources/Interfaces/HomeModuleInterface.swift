//
//  HomeModuleInterface.swift
//  DependencyManagerKit
//
//  Created by Yasin Akbas on 8.07.2022.
//  Copyright © 2022 com.yasinkbas.DependencyManagerKit. All rights reserved.
//

import UIKit
import CommonKit

public protocol HomeModuleInterface {
    func homeViewController(with navigationController: UINavigationController?, arguments: HomePresenterArguments) -> UIViewController
}
