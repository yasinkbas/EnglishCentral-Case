//
//  LoadingView.swift
//  CommonKit
//
//  Created by Yasin Akbas on 17.07.2022.
//  Copyright © 2022 com.yasinkbas.CommonKit. All rights reserved.
//

import UIKit
import UILab
import CommonKit

public protocol LoadingViewInterface: AnyObject {
    func prepareUI()
}

private extension LoadingView {
    enum Constant {
        static let backgroundColor: UIColor = Colors.dark
        static let cornerRadius: CGFloat = 16
    }
}

public class LoadingView: UIView {
    var presenter: LoadingPresenterInterface! {
        didSet {
            presenter.load()
        }
    }
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .yellow
        return activityIndicator
    }()
}

// MARK: - LoadingViewInterface
extension LoadingView: LoadingViewInterface {
    public func prepareUI() {
        backgroundColor = Constant.backgroundColor
        layer.cornerRadius = Constant.cornerRadius
        
        addSubview(activityIndicator)
        activityIndicator.set(.center(self))
        activityIndicator.startAnimating()
    }
}
