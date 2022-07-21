//
//  CoreDataContainer.swift
//  PersistentManagerKit
//
//  Created by Yasin Akbas on 20.07.2022.
//  Copyright © 2022 com.yasinkbas.PersistentManagerKit. All rights reserved.
//

import Foundation

public enum CoreDataContainer: String, CaseIterable {
    case map
    
    public var name: String {
        rawValue.capitalized
    }
}
