//
//  File.swift
//  
//
//  Created by MEI YIN LO on 2023/5/22.
//

import Foundation
import ComposableArchitecture

public struct RequestInternalParameterFeature: ReducerProtocol{
    
    
    public enum Action:Equatable{
        
    }
    public func reduce(into state: inout ComposableParameter, action: Action) ->EffectTask<Action> {
        switch action{
        }
        return .none
    }
}
