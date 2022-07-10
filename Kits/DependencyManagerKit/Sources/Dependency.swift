//
//  Dependency.swift
//  DependencyManagerKit
//
//  Created by Yasin Akbas on 8.07.2022.
//  Copyright © 2022 com.yasinkbas.DependencyManagerKit. All rights reserved.
//

import Foundation

@propertyWrapper
public final class Dependency<Value> {
    private var value: Value?
    private let engine: DependencyEngine
    
    public init(engine: DependencyEngine = .shared) {
        self.engine = engine
    }
    
    public convenience init(wrappedValue: Value, engine: DependencyEngine = .shared) {
        self.init(engine: engine)
        self.value = wrappedValue
    }
    
    public var wrappedValue: Value {
        get {
            if let value = value {
                return value
            } else {
                let value: Value = engine.read(for: Value.self)
                self.value = value
                return value
            }
        }
        set {
            value = newValue
        }
    }
}
