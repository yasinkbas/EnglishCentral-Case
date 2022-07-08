//
//  HomeViewController.swift
//  HomeModule
//
//  Created by Yasin Akbas on 8.07.2022.
//  Copyright © 2022 com.yasinkbas.HomeModule. All rights reserved.
//

import UIKit

protocol HomeViewInterface: AnyObject {
    func prepareUI()
}

public class HomeViewController: UIViewController {
    var presenter: HomePresenterInterface!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
    }
}

// MARK: - HomeViewInterface
extension HomeViewController: HomeViewInterface {
    func prepareUI() {
        view.backgroundColor = .purple
    }
}
