//
//  UIView+Extensions.swift
//  CommonKit
//
//  Created by Yasin Akbas on 12.07.2022.
//  Copyright © 2022 com.yasinkbas.CommonKit. All rights reserved.
//

import UIKit
import UILab

public extension UIView {
    func embed(in view: UIView) {
        view.addSubview(self)
        set(.leadingOf(view), .topOf(view), .trailingOf(view), .bottomOf(view))
    }
}
