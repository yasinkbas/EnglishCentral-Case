//
//  PlacesAPI.swift
//  NetworkKit
//
//  Created by Yasin Akbas on 8.07.2022.
//  Copyright © 2022 com.yasinkbas.NetworkKit. All rights reserved.
//

import CommonKit
import NLab

public struct PlacesAPI {
    private let client = NLClient(baseURL: .init(string: "https://places.ls.hereapi.com/places/v1/")!)
    
    public init() { }
    
    public func autoSuggest(at: String, q: String) -> NLTaskDirector<APIResponse<AutoSuggestResponse>, Empty> {
        NLTaskPoint(client: client)
            .path("autosuggest")
            .method(.get)
            .addParameter(.init(name: "at", value: at))
            .addParameter(.init(name: "q", value: q))
            .addParameter(.init(name: "apiKey", value: NetworkConfigs.placesApiKey))
            .build().and.direct()
    }
}
