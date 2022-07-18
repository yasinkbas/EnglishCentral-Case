//
//  MapView.swift
//  MapViewKit
//
//  Created by Yasin Akbas on 12.07.2022.
//  Copyright © 2022 com.yasinkbas.MapViewKit. All rights reserved.
//

import UIKit
import MapKit
import UILab
import CommonKit
import CoreViewKit

public protocol MapViewViewInterface: AlertShowable {
    func prepareUI()
    func centerUserLocation(region: MKCoordinateRegion)
    func addAnnotation(_ annotation: MKPointAnnotation)
    func removeAllAnnotations()
    func fitAnnotations()
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
        mapView.showsCompass = false
        return mapView
    }()
}

// MARK: - MapViewViewInterface
extension MapView: MapViewViewInterface {
    public func prepareUI() {
        coreMapView.embed(in: self)
    }
    
    public func centerUserLocation(region: MKCoordinateRegion) {
        coreMapView.setRegion(region, animated: true)
    }
    
    public func addAnnotation(_ annotation: MKPointAnnotation) {
        DispatchQueue.main.async {
            self.coreMapView.addAnnotation(annotation)
        }
    }
    
    public func removeAllAnnotations() {
        DispatchQueue.main.async {
            self.coreMapView.removeAnnotations(self.coreMapView.annotations)
        }
    }
    
    public func fitAnnotations() {
        coreMapView.showAnnotations(coreMapView.annotations, animated: true)
    }
}

// MARK: - MKMapViewDelegate
extension MapView: MKMapViewDelegate { }
