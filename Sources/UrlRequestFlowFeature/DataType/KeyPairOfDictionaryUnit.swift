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
    var keyOfKey : String
    var keyOfValue : String
    
    
}
