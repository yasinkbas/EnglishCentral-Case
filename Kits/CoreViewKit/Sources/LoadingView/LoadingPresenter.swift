//
//  LoadingPresenter.swift
//  CommonKit
//
//  Created by Yasin Akbas on 17.07.2022.
//  Copyright © 2022 com.yasinkbas.CommonKit. All rights reserved.
//

import Foundation

public protocol LoadingPresenterInterface: AnyObject {
    func load()
}

public class LoadingPresenter {
    private weak var view: LoadingViewInterface?

    public init(view: LoadingViewInterface) {
        self.view = view
    }
}

// MARK: - LoadingPresenterInterface
extension LoadingPresenter: LoadingPresenterInterface {
    public func load() {
        view?.prepareUI()
    }
}
