//
//  File.swift
//  
//
//  Created by MEI YIN LO on 2023/5/22.
//

import Foundation
import ComposableArchitecture


public struct ComposableValue: Equatable{
    public var value : String
    public var lookupKey : String?
}

public struct ComposableParameter: Equatable, Identifiable{
    public let id: UUID
    public let key: String
    public var value: ComposableValue
   
    
    public static func getParameterValueByKey(
        key: String
        , from: IdentifiedArrayOf<ComposableParameter>
        , lookup: IdentifiedArrayOf<SharableParameter>
    )->String?{
        guard let internalParameter = from.first(where: {$0.key == key}) else{return nil}
        if let lookupKey = internalParameter.value.lookupKey{return lookup.first {$0.key == lookupKey}!.value}
        else{return internalParameter.value.value}
    }
    
    public static func convertKeyValuePairsToDictionary(
        pairs: IdentifiedArrayOf<KeyPairOfDictionaryUnit>
        , from: IdentifiedArrayOf<ComposableParameter>
        , lookup: IdentifiedArrayOf<SharableParameter>
    )->[String:String]?{
        if pairs.count == 0{return nil}
        return pairs.reduce(into: [String:String]()) {
            if let key = getParameterValueByKey(key: $1.keyOfKey, from: from, lookup: lookup),
               let value = getParameterValueByKey(key: $1.keyOfValue, from: from, lookup: lookup){
                $0[key] = value
            }
        }
    }
}
