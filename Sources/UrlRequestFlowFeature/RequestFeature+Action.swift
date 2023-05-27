//
//  File.swift
//  
//
//  Created by MEI YIN LO on 2023/5/22.
//

import Foundation
import ComposableArchitecture

public extension RequestFeature{
    public enum Action:Equatable{
        case setUrlComponent(HttpParameterKey,String)
        case setUrlComponentByParameterKey(HttpParameterKey,String)
        
        case addUrlComponentQueryItem(RequestInternalParameterFeature.State,RequestInternalParameterFeature.State)
        case setUrlComponentQueryItem(RequestInternalParameterFeature.State,RequestInternalParameterFeature.State)
        
        case setHttpBody(RequestInternalParameterFeature.State,RequestInternalParameterFeature.State)
        case setHttpHead(RequestInternalParameterFeature.State,RequestInternalParameterFeature.State)
        case setHttpMethod(HttpMethod)
        case setOutputParameterConfiguration(HttpResponseOutputParameterConfiguration)
        case outputResponseAsUrl(responseUrl: URL)
        case outuptResponseAsData(Data)
        
        case joinActionSharableParameterFeature(id: SharableParameterFeature.State.ID, action: SharableParameterFeature.Action)
        case joinActionUrlComponentQueryItem(id:KeyPairOfDictionaryUnitFeature.State.ID, action: KeyPairOfDictionaryUnitFeature.Action)
        
        case outputParameterUpdated
        case run
        
    }
}

