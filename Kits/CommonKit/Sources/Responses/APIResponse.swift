//
//  APIResponse.swift
//  CommonKit
//
//  Created by Yasin Akbas on 11.07.2022.
//  Copyright © 2022 com.yasinkbas.CommonKit. All rights reserved.
//

import Foundation

public struct APIResponse<T: Decodable>: Decodable {
    public let results: [T]
}
