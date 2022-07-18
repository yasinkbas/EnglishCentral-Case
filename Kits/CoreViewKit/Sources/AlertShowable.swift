//
//  AlertShowable.swift
//  CoreViewKit
//
//  Created by Yasin Akbas on 18.07.2022.
//  Copyright © 2022 com.yasinkbas.CoreViewKit. All rights reserved.
//

import UIKit

public protocol AlertShowable: AnyObject {
    func showAlert(message: String)
}

public extension AlertShowable where Self: UIViewController {
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertController.addAction(.init(title: "Ok", style: .default))
        DispatchQueue.main.async {
            self.present(alertController, animated: true)
        }
    }
}

public extension AlertShowable where Self: UIView {
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertController.addAction(.init(title: "Ok", style: .default))
        DispatchQueue.main.async {
            self.window?.rootViewController?.present(alertController, animated: true)
        }
    }
}
