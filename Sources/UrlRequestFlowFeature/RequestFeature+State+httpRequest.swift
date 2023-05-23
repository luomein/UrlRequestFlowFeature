//
//  File.swift
//  
//
//  Created by MEI YIN LO on 2023/5/22.
//

import Foundation
import ComposableArchitecture

public extension RequestFeature.State{
    public func getParameterValueByKey(key: String)->String?{
        return ComposableParameter.getParameterValueByKey(
            key: key
            , from: internalParameters
            , lookup: inputParameters)
    }
    public var httpRequest : URLRequest{
        get{
            var request = URLRequest(url: urlcomponents.url!)
            request.httpBody = httpBody
            request.httpMethod = httpMethod!.rawValue
            request.allHTTPHeaderFields = httpHead
            return request
        }
    }
    public var httpBody : Data?{
        switch httpBodyContentType {
        case .dict:
            if let dict = ComposableParameter.convertKeyValuePairsToDictionary(pairs: httpBodyKeyValuePairs, from: internalParameters, lookup: inputParameters){
                let trans: (String, String) -> String = { k, v in
                  return rfc3986encode(k) + "=" + rfc3986encode(v)
                }
                return dict.map(trans).joined(separator: "&").data(using: httpBodyContentEncoding)
            }
            return nil
        }
        
    }
    public var httpHead : [String:String]?{
        return ComposableParameter.convertKeyValuePairsToDictionary(pairs: httpHeadKeyValuePairs, from: internalParameters, lookup: inputParameters)
    }
    public var urlqueryItems : [URLQueryItem]?{
        if urlQueryItemKeyValuePairs.count == 0{return nil}
        return urlQueryItemKeyValuePairs
               .compactMap{
                guard let key = getParameterValueByKey(key: $0.keyOfKey) else{return nil}
                return URLQueryItem(name: key, value: getParameterValueByKey(key: $0.keyOfValue)) }
    }
    public var urlcomponents : URLComponents{
        var urlcomponents = URLComponents()
        urlcomponents.scheme = getParameterValueByKey(key: HttpParameterKey.urlcomponents_scheme.rawValue)
        urlcomponents.user = getParameterValueByKey(key: HttpParameterKey.urlcomponents_user.rawValue)
        urlcomponents.password = getParameterValueByKey(key: HttpParameterKey.urlcomponents_password.rawValue)
        urlcomponents.host = getParameterValueByKey(key: HttpParameterKey.urlcomponents_host.rawValue)
        if let port = getParameterValueByKey(key: HttpParameterKey.urlcomponents_port.rawValue) {urlcomponents.port = Int(port)}
        urlcomponents.path = getParameterValueByKey(key: HttpParameterKey.urlcomponents_path.rawValue) ?? ""
        
        urlcomponents.queryItems = urlqueryItems
        
        return urlcomponents
    }
}
