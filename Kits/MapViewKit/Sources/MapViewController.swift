//
//  MapViewController.swift
//  MapViewKit
//
//  Created by Yasin Akbas on 12.07.2022.
//  Copyright © 2022 com.yasinkbas.MapViewKit. All rights reserved.
//

import UIKit
import MapKit
import UILab
import CommonKit

public protocol MapViewViewInterface: AnyObject {
    func prepareUI()
    func centerUserLocation(region: MKCoordinateRegion)
    func addAnnotation(_ annotation: MKPointAnnotation)
}

public class MapView: UIView {
    public var presenter: MapViewPresenterInterface! {
        didSet {
            presenter.load()
        }
    }
    
    lazy var coreMapView: MKMapView = {
        let mapView = MKMapView()
        mapView.delegate = self
        mapView.showsUserLocation = true
        return mapView
    }()
}

// MARK: - MapViewViewInterface
extension MapView: MapViewViewInterface {
    public func prepareUI() {
        coreMapView.embed(in: self)
    }
    
    public func centerUserLocation(region: MKCoordinateRegion) {
        // TODO: update parameter as region
        coreMapView.setRegion(region, animated: true)
    }
    
    public func addAnnotation(_ annotation: MKPointAnnotation) {
        coreMapView.addAnnotation(annotation)
    }
}

// MARK: - MKMapViewDelegate
extension MapView: MKMapViewDelegate {
    
}
