//
//  HomePresenter.swift
//  HomeModule
//
//  Created by Yasin Akbas on 8.07.2022.
//  Copyright © 2022 com.yasinkbas.HomeModule. All rights reserved.
//

import Foundation
import CommonKit

protocol HomePresenterInterface: AnyObject {
    func viewDidLoad()
}

final class HomePresenter {
    private weak var view: HomeViewInterface?
    private let router: HomeRouterInterface
    private let interactor: HomeInteractorInterface
    private let arguments: HomePresenterArguments
    
    init(
        view: HomeViewInterface,
        router: HomeRouterInterface,
        interactor: HomeInteractorInterface,
        arguments: HomePresenterArguments
    ) {
        self.view = view
        self.router = router
        self.interactor = interactor
        self.arguments = arguments
    }
}

// MARK: - HomePresenterInterface
extension HomePresenter: HomePresenterInterface {
    func viewDidLoad() {
        view?.prepareUI()
    }
}

// MARK: - HomeInteractorOutput
extension HomePresenter: HomeInteractorOutput {
    
}
