//
//  HomeInteractor.swift
//  HomeModule
//
//  Created by Yasin Akbas on 8.07.2022.
//  Copyright © 2022 com.yasinkbas.HomeModule. All rights reserved.
//

import Foundation

protocol HomeInteractorInterface: AnyObject {

}

protocol HomeInteractorOutput: AnyObject {
    
}

final class HomeInteractor {
    weak var output: HomeInteractorOutput?
}

// MARK: - HomeInteractorInterface
extension HomeInteractor: HomeInteractorInterface {
    
}
