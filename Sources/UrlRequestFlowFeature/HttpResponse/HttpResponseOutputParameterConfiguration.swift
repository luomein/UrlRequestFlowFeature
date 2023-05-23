//
//  File.swift
//  
//
//  Created by MEI YIN LO on 2023/5/22.
//

import Foundation


public struct HttpResponseOutputParameterConfiguration: Equatable, Identifiable{
    public let id: UUID
    public let reader : HttpResponseReader
    
    public enum HttpResponseReader : Equatable{
        
        case Url(path: UrlComponentsKey , outputParameterKey: String)
        case JsonDict(dictKey: String, outputParameterKey: String)
    }
}
