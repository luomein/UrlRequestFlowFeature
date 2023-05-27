//
//  File.swift
//  
//
//  Created by MEI YIN LO on 2023/5/27.
//

import Foundation
import ComposableArchitecture

public struct SharableParameterFeature: ReducerProtocol{
    
    
    public enum Action:Equatable{
        case setName(String)
        case setValue(String)
    }
    public func reduce(into state: inout SharableParameter, action: Action) ->EffectTask<Action> {
        switch action{
        case .setName(let value):
            state.name = value
        case .setValue(let value):
            state.value = value
        }
        return .none
    }
}
