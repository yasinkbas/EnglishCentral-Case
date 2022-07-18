//
//  LoadingView.swift
//  CommonKit
//
//  Created by Yasin Akbas on 17.07.2022.
//  Copyright © 2022 com.yasinkbas.CommonKit. All rights reserved.
//

import UIKit
import UILab

public protocol LoadingViewInterface: AnyObject {
    func prepareUI()
}

private extension LoadingView {
    enum Constant {
        static let backgroundColor: UIColor = #colorLiteral(red: 0.2274622619, green: 0.234510392, blue: 0.1947289109, alpha: 1)
        static let cornerRadius: CGFloat = 16
    }
}

public class LoadingView: UIView {
    var presenter: LoadingPresenterInterface! {
        didSet {
            presenter.load()
        }
    }
    
    lazy var activityIndicator: UIActivityIndicatorView = {
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
