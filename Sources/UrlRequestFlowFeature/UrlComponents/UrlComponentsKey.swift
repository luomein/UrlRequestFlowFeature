//
//  File.swift
//  
//
//  Created by MEI YIN LO on 2023/5/22.
//

import Foundation

public enum UrlComponentsKey: Equatable{
    case scheme
    case user
    case password
    case host
    case port
    case path
    case queryItem(key: String)
    
    func getUrlComponentsValueByKey(urlcomonents: URLComponents)->String?{
        switch self{
        case .scheme :
            return urlcomonents.scheme
        case .user :
            return urlcomonents.user
        case .password :
            return urlcomonents.password
        case .host :
            return urlcomonents.host
        case .port :
            if let port = urlcomonents.port{return "\(port)"}
            return nil
        case .path :
            return urlcomonents.path
        case .queryItem(let key):
            return urlcomonents.queryItems?.first(where: {
                $0.name == key
            })?.value
        }
    }
}
