//
//  HomeRouter.swift
//  HomeModule
//
//  Created by Yasin Akbas on 8.07.2022.
//  Copyright © 2022 com.yasinkbas.HomeModule. All rights reserved.
//

import UIKit
import CommonKit

protocol HomeRouterInterface: AnyObject {
    
}

final class HomeRouter {
    
    private weak var navigationController: UINavigationController?
    
    init(with navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    static func createModule(using navigationController: UINavigationController? = nil, arguments: HomePresenterArguments) -> HomeViewController {
        let view = HomeViewController()
        let interactor = HomeInteractor()
        let router = HomeRouter(with: navigationController)
        let presenter = HomePresenter(view: view, router: router, interactor: interactor, arguments: arguments)
        view.presenter = presenter
        interactor.output = presenter
        return view
    }
}

// MARK: - HomeRouterInterface
extension HomeRouter: HomeRouterInterface {
    
}

