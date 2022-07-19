//
//  AutoSuggestResponse.swift
//  CommonKit
//
//  Created by Yasin Akbas on 9.07.2022.
//  Copyright © 2022 com.yasinkbas.CommonKit. All rights reserved.
//

import Foundation

public struct AutoSuggestResponse: Hashable, Decodable {
    public let highlightedTitle, title, href, id, category, categoryTitle, vicinity, highlightedVicinity: String?
    public let position: [Double]?
    public let distance: Int?
    public let chainIds: [String]?
    public let bbox: [Double]?
    
    public init(highlightedTitle: String? = nil,
                title: String? = nil,
                href: String? = nil,
                id: String? = nil,
                category: String? = nil,
                categoryTitle: String? = nil,
                vicinity: String? = nil,
                position: [Double]? = nil,
                highlightedVicinity: String? = nil,
                distance: Int? = nil,
                chainIds: [String]? = nil,
                bbox: [Double]? = nil) {
        self.highlightedTitle = highlightedTitle
        self.title = title
        self.href = href
        self.id = id
        self.category = category
        self.categoryTitle = categoryTitle
        self.vicinity = vicinity
        self.position = position
        self.highlightedVicinity = highlightedVicinity
        self.distance = distance
        self.chainIds = chainIds
        self.bbox = bbox
    }
}
