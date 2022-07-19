//
//  HomeNavigationView.swift
//  HomeModule
//
//  Created by Yasin Akbas on 12.07.2022.
//  Copyright © 2022 com.yasinkbas.HomeModule. All rights reserved.
//

import UIKit
import CommonKit

protocol HomeNavigationViewInterface: AnyObject {
    func prepareUI()
}

final class HomeNavigationView: UIView {
    var presenter: HomeNavigationViewPresenterInterface! {
        didSet {
            presenter.load()
        }
    }
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.sizeToFit()
        searchBar.backgroundImage = UIImage()
        searchBar.barTintColor = .clear
        return searchBar
    }()
    
    private lazy var searchBarContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = Colors.darkGray
        view.layer.cornerRadius = 16
        return view
    }()
    
    private lazy var searchButton: UIButton = {
        let button = UIButton()
        button.setTitle("Search", for: .normal)
        button.backgroundColor = Colors.darkGray
        button.layer.cornerRadius = 16
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.addTarget(self, action: #selector(searchButtonTapped), for: .touchDown)
        return button
    }()
    
    @objc
    private func searchButtonTapped() {
        presenter.searchButtonTapped()
    }
}

// MARK: - HomeNavigationViewInterface
extension HomeNavigationView: HomeNavigationViewInterface {
    func prepareUI() {
        backgroundColor = .clear
        
        addSubview(searchBarContainerView)
        searchBarContainerView.set(.leadingOf(self), .topOf(self), .trailingOf(self, 90))
        searchBar.embed(in: searchBarContainerView)
        
        addSubview(searchButton)
        searchButton.set(.leading(searchBarContainerView.trailing, 20), .trailingOf(self), .heightOf(searchBarContainerView))
    }
}

// MARK: - UISearchBarDelegate
extension HomeNavigationView: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter.searchBar(textDidChange: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        presenter.searchButtonTapped()
    }
}
