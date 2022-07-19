//
//  Sequence+Extensions.swift
//  CommonKit
//
//  Created by Yasin Akbas on 17.07.2022.
//  Copyright © 2022 com.yasinkbas.CommonKit. All rights reserved.
//

import Foundation

public extension Array {
    subscript(safe index: Int) -> Element? {
           guard index >= 0, index < endIndex else {
               return nil
           }

           return self[index]
       }
}
