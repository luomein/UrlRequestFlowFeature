//
//  File.swift
//  
//
//  Created by MEI YIN LO on 2023/5/22.
//

import Foundation

public extension RequestFeature.State{
    public var oathParameter : OAuth2AsyncManager.Parameter{
        let callbackURLScheme = getParameterValueByKey(key: HttpParameterKey.webauth_callbackURLScheme.rawValue )!
        let prefersEphemeralWebBrowserSession = Bool(getParameterValueByKey(key:
                                                                                    HttpParameterKey.webauth_prefersEphemeralWebBrowserSession.rawValue)! )!
        return OAuth2AsyncManager.Parameter(url: urlcomponents.url!
                                                     , callbackURLScheme: callbackURLScheme
                                            , prefersEphemeralWebBrowserSession: prefersEphemeralWebBrowserSession )
    }
}
