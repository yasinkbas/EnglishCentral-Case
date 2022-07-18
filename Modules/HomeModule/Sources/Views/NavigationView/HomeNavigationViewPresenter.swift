//
//  HomeNavigationViewPresenter.swift
//  HomeModule
//
//  Created by Yasin Akbas on 12.07.2022.
//  Copyright © 2022 com.yasinkbas.HomeModule. All rights reserved.
//

import Foundation

protocol HomeNavigationViewPresenterDelegate: AnyObject {
    func searchButtonTapped(searchText: String)
}

protocol HomeNavigationViewPresenterInterface: AnyObject {
    func load()
    func searchButtonTapped()
    func searchBar(textDidChange searchText: String)
}

class HomeNavigationViewPresenter {
    private weak var view: HomeNavigationViewInterface?
    private weak var delegate: HomeNavigationViewPresenterDelegate?

    private var searchText: String = ""
    
    init(view: HomeNavigationViewInterface, delegate: HomeNavigationViewPresenterDelegate) {
        self.view = view
        self.delegate = delegate
    }
}

// MARK: - HomeNavigationViewPresenterInterface
extension HomeNavigationViewPresenter: HomeNavigationViewPresenterInterface {
    func load() {
        view?.prepareUI()
    }
    
    func searchButtonTapped() {
        delegate?.searchButtonTapped(searchText: searchText)
    }
    
    func searchBar(textDidChange searchText: String) {
        self.searchText = searchText
    }
}
