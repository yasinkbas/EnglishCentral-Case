//
//  NetworkConfigs.swift
//  NetworkKit
//
//  Created by Yasin Akbas on 10.07.2022.
//  Copyright © 2022 com.yasinkbas.NetworkKit. All rights reserved.
//

import Foundation

public class NetworkConfigs {
    static var placesApiKey: String = ""
    
    public static func register(placesApiKey: String) {
        Self.placesApiKey = placesApiKey
    }
}
