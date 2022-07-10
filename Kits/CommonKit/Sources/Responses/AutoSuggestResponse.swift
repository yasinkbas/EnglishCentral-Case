//
//  AutoSuggestResponse.swift
//  CommonKit
//
//  Created by Yasin Akbas on 9.07.2022.
//  Copyright © 2022 com.yasinkbas.CommonKit. All rights reserved.
//

import Foundation

public struct AutoSuggestResponse: Decodable {
    public let highlightedTitle: String
    public let title: String
    public let href: String
    public let resultType: ResultType
    public let id, category, categoryTitle, vicinity: String?
    public let position: [Double]?
    public let highlightedVicinity: String?
    public let distance: Int?
    public let chainIds: [String]?
    public let bbox: [Double]?
    
    enum CodingKeys: CodingKey {
        case highlightedTitle
        case title
        case href
        case resultType
        case id
        case category
        case categoryTitle
        case vicinity
        case position
        case highlightedVicinity
        case distance
        case chainIds
        case bbox
    }
}

public enum ResultType: String, Codable {
    case address = "address"
    case chain = "chain"
    case place = "place"
}
