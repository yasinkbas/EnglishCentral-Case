//
//  HomeViewController.swift
//  HomeModule
//
//  Created by Yasin Akbas on 8.07.2022.
//  Copyright © 2022 com.yasinkbas.HomeModule. All rights reserved.
//

import UIKit
import UILab
import DependencyManagerKit
import MapViewKit

protocol HomeViewInterface: AnyObject {
    func prepareUI()
    func prepareNavigationView() -> HomeNavigationViewPresenter
    func prepareMapView() -> MapViewPresenterInterface
}

extension HomeViewController {
    struct Constants {
        static let barColor: UIColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        static let barButtonColor: UIColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        static let topViewHeight: CGFloat = 55
    }
}

public class HomeViewController: UIViewController {
    var presenter: HomePresenterInterface!
    
    var mapView: MapView!
    var navigationView: HomeNavigationView!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
    }
}

// MARK: - HomeViewInterface
extension HomeViewController: HomeViewInterface {
    func prepareUI() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        view.backgroundColor = #colorLiteral(red: 0.1726958752, green: 0.1748272181, blue: 0.1423502862, alpha: 1)
        
        view.addSubview(mapView)
        mapView.set(.leadingOf(view), .topOf(view), .trailingOf(view), .bottomOf(view))
        
        view.addSubview(navigationView)
        navigationView.set(.leadingOf(view, 15), .top(view.safeAreaLayoutGuide.topAnchor, 15), .trailingOf(view, 15), .height(50))
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:))))
    }
    
    func prepareNavigationView() -> HomeNavigationViewPresenter {
        navigationView = HomeNavigationView()
        let presenter = HomeNavigationViewPresenter(view: navigationView,
                                                    delegate: presenter.navigationViewDelegate)
        navigationView.presenter = presenter
        return presenter
    }
    
    func prepareMapView() -> MapViewPresenterInterface {
        mapView = MapView()
        let presenter = MapViewPresenter(view: mapView)
        mapView.presenter = presenter
        return presenter
    }
}
