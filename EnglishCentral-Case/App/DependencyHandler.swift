//
//  DependencyHandler.swift
//  EnglishCentral-Case
//
//  Created by Yasin Akbas on 9.07.2022.
//  Copyright © 2022 com.yasinkbas.EnglishCentral-Case. All rights reserved.
//

import DependencyManagerKit
import HomeModule

final class DependencyHandler {
    func registerDependencies() {
        DependencyEngine.shared.register(value: HomeModule(), for: HomeModuleInterface.self)
    }
}
