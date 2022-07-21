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
import CoreViewKit
import MapKit
import PersistentManagerKit

protocol HomeViewInterface: LoadingShowable, AlertShowable {
    func prepareUI()
    func prepareNavigationView(delegate: HomeNavigationViewPresenterDelegate) -> HomeNavigationViewPresenterInterface
    func prepareMapView() -> MapViewPresenterInterface
    func prepareHistoryView(delegate: HomeHistoryPresenterDelegate) -> HomeHistoryPresenterInterface
    func addAnnotation(_ annotation: MKPointAnnotation)
    func removeAllAnnotations()
    func fitMapAnnotations()
    func showHistoryView()
    func hideHistoryView()
    func hideKeyboard()
}

private extension HomeViewController {
    struct Constant {
        static let backgroundColor: UIColor = #colorLiteral(red: 0.1726958752, green: 0.1748272181, blue: 0.1423502862, alpha: 1)
        
        static let myLocationIcon = UIImage(systemName: "location.fill")?.withTintColor(.white)
        static let myLocationIconCornerRadius: CGFloat = 16
    }
}

public class HomeViewController: UIViewController {
    var presenter: HomePresenterInterface!
    
    var mapView: MapView!
    var navigationView: HomeNavigationView!
    var historyView: HomeHistoryView!
    
    lazy var showMyLocationButton: UIButton = {
        let button = UIButton()
        button.setImage(Constant.myLocationIcon, for: .normal)
        button.layer.cornerRadius = Constant.myLocationIconCornerRadius
        button.backgroundColor = Constant.backgroundColor
        button.tintColor = .white
        button.addTarget(self, action: #selector(showMyLocationButtonTapped), for: .touchUpInside)
        return button
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
    }
    
    @objc
    private func showMyLocationButtonTapped() {
        presenter.showMyLocationButtonTapped()
    }
    
    @objc
    private func emptyViewTapped(_ sender: UITapGestureRecognizer) {
        presenter.emptyViewTapped()
    }
}

// MARK: - HomeViewInterface
extension HomeViewController: HomeViewInterface {
    func prepareUI() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        view.backgroundColor = Constant.backgroundColor
        
        view.addSubview(mapView)
        mapView.set(.leadingOf(view), .topOf(view), .trailingOf(view), .bottomOf(view))
        
        view.addSubview(navigationView)
        navigationView.set(.leadingOf(view, 15), .top(view.safeAreaLayoutGuide.topAnchor, 15), .trailingOf(view, 15), .height(50))
        
        view.addSubview(showMyLocationButton)
        showMyLocationButton.set(.trailingOf(view, 15), .bottom(view.safeAreaLayoutGuide.bottomAnchor, 15), .width(40), .height(40))
        
        view.addSubview(historyView)
        historyView.set(.top(navigationView.bottom, -2), .leading(navigationView.leading), .trailing(navigationView.trailing, 90), .height(0))
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(emptyViewTapped(_:)))
        tapGesture.cancelsTouchesInView = false
        mapView.addGestureRecognizer(tapGesture)
    }
    
    func prepareNavigationView(delegate: HomeNavigationViewPresenterDelegate) -> HomeNavigationViewPresenterInterface {
        navigationView = HomeNavigationView()
        let presenter = HomeNavigationViewPresenter(view: navigationView,
                                                    delegate: delegate)
        navigationView.presenter = presenter
        return presenter
    }
    
    func prepareMapView() -> MapViewPresenterInterface {
        mapView = MapView()
        let presenter = MapViewPresenter(view: mapView)
        mapView.presenter = presenter
        return presenter
    }
    
    func prepareHistoryView(delegate: HomeHistoryPresenterDelegate) -> HomeHistoryPresenterInterface {
        historyView = HomeHistoryView()
        let presenter = HomeHistoryPresenter(view: historyView, delegate: delegate)
        historyView.presenter = presenter
        return presenter
    }
    
    func addAnnotation(_ annotation: MKPointAnnotation) {
        mapView.addAnnotation(annotation)
    }
    
    func removeAllAnnotations() {
        mapView.removeAllAnnotations()
    }
    
    func fitMapAnnotations() {
        mapView.fitAnnotations()
    }
    
    func showHistoryView() {
        historyView.get(.height).first?.constant = historyView.viewHeight
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }
    
    func hideHistoryView() {
        historyView.get(.height).first?.constant = 0
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }
    
    func hideKeyboard() {
        view.endEditing(true)
    }
}
