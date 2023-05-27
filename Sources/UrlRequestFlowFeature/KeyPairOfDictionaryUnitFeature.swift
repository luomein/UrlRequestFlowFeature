//
//  File.swift
//  
//
//  Created by MEI YIN LO on 2023/5/27.
//

import Foundation
import ComposableArchitecture

public struct KeyPairOfDictionaryUnitFeature: ReducerProtocol{
    
    
    public enum Action:Equatable{
        case setKeyOfKey(ComposableParameter)
        case setKeyOfValue(ComposableParameter)
        
        public func updateParameter(parameter: ComposableParameter)->Self{
            switch self{
            case .setKeyOfKey(_):
                return .setKeyOfKey(parameter)
            case .setKeyOfValue(_):
                return .setKeyOfValue(parameter)
            }
        }
    }
    public func reduce(into state: inout KeyPairOfDictionaryUnit, action: Action) ->EffectTask<Action> {
//        switch action{
//        case .setKeyOfKey(let value):
//            state.keyOfKey = value.key
//        case .setKeyOfValue(let value):
//            state.keyOfValue = value.key
//        }
        return .none
    }
}
