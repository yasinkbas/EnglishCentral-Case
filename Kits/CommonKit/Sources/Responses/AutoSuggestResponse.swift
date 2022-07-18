//
//  AutoSuggestResponse.swift
//  CommonKit
//
//  Created by Yasin Akbas on 9.07.2022.
//  Copyright © 2022 com.yasinkbas.CommonKit. All rights reserved.
//

import Foundation

public struct AutoSuggestResponse: Hashable, Decodable {
    public let highlightedTitle: String?
    public let title: String?
    public let href: String?
    public let id, category, categoryTitle, vicinity: String?
    public let position: [Double]?
    public let highlightedVicinity: String?
    public let distance: Int?
    public let chainIds: [String]?
    public let bbox: [Double]?
}
