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
}

public class MapView: UIView {
    public var presenter: MapViewPresenterInterface! {
        didSet {
            presenter.load()
        }
    }
    
    lazy var coreMapView: MKMapView = {
        let mapView = MKMapView()
        return mapView
    }()
}

// MARK: - MapViewViewInterface
extension MapView: MapViewViewInterface {
    public func prepareUI() {
        coreMapView.embed(in: self)
    }
}
