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
        case setUrlComponentQueryItem(RequestInternalParameterFeature.State,RequestInternalParameterFeature.State)
        case setHttpBody(RequestInternalParameterFeature.State,RequestInternalParameterFeature.State)
        case setHttpHead(RequestInternalParameterFeature.State,RequestInternalParameterFeature.State)
        case setHttpMethod(HttpMethod)
        case setOutputParameterConfiguration(HttpResponseOutputParameterConfiguration)
        case outputResponseAsUrl(responseUrl: URL)
        case outuptResponseAsData(Data)
        
        case outputParameterUpdated
        case run
        
    }
}

