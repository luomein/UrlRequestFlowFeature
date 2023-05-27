//
//  File.swift
//  
//
//  Created by MEI YIN LO on 2023/5/22.
//

import Foundation
import ComposableArchitecture

public struct SharableParameter: Equatable, Identifiable{
    public var id: UUID
    public var key: String
    public var name: String
    public var value: String
    
    public init(id: UUID, key: String, name: String, value: String) {
        self.id = id
        self.key = key
        self.name = name
        self.value = value
    }
}
