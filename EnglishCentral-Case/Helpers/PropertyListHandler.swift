//
//  StringsFileManager.swift
//  EnglishCentral-Case
//
//  Created by Yasin Akbas on 10.07.2022.
//  Copyright © 2022 com.yasinkbas.EnglishCentral-Case. All rights reserved.
//

import Foundation

final class PropertyListHandler {
    enum PropertyListError: Error {
        case pathNotFound
        case decodeError
    }
    
    func read<T: Decodable>(fileName: String) throws -> T {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "plist") else {
            throw PropertyListError.pathNotFound
        }
        do {
            let data = try Data(contentsOf: url)
            let result = try PropertyListDecoder().decode(T.self, from: data)
            return result
        } catch {
            throw PropertyListError.decodeError
        }
    }
}
