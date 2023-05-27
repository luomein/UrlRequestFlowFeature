//
//  File.swift
//  
//
//  Created by MEI YIN LO on 2023/5/22.
//

import Foundation
import ComposableArchitecture

public struct KeyPairOfDictionaryUnit : Equatable, Identifiable{
    public let id: UUID
    public var keyOfKey : String
    public var keyOfValue : String
    
    public init(id: UUID, keyOfKey: String, keyOfValue: String) {
        self.id = id
        self.keyOfKey = keyOfKey
        self.keyOfValue = keyOfValue
    }
}
