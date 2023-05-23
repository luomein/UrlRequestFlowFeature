//
//  OAuth2AsyncManager.swift
//  labAnyAuthApi
//
//  Created by MEI YIN LO on 2023/3/19.
//

import Foundation

import AuthenticationServices
import ComposableArchitecture

public struct OAuth2DependencyManager : DependencyKey{
    var fetch : ( OAuth2AsyncManager.Parameter) async throws -> URL

    public static let liveValue: OAuth2DependencyManager = Self(fetch: OAuth2AsyncManager().webAuthAsyncWrapper(parameter:))
    
    
    public static func getOAuth2DependencyManager(path: String, code : String?)->OAuth2DependencyManager{
        if let code = code{
            return Self(fetch: {_ in
                
                return  URL(string: "\(path)\(code)")!
            })
        }
        else{
            return .liveValue
        }
    }
}
extension DependencyValues{
    var oauth2DependencyManager : OAuth2DependencyManager{
        get{self[OAuth2DependencyManager.self]}
        set{self[OAuth2DependencyManager.self] = newValue}
    }
}

public class OAuth2AsyncManager: NSObject, ASWebAuthenticationPresentationContextProviding {
    public func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return ASPresentationAnchor()
    }
    func webAuth(url: URL, callbackURLScheme: String, prefersEphemeralWebBrowserSession: Bool,
                 completion: @escaping (Result<URL, Error>) -> Void){
        let authSession = ASWebAuthenticationSession(url: url, callbackURLScheme: callbackURLScheme) { (url, error) in
            if let error = error {
                completion(.failure(error))
            } else if let url = url {
                completion(.success(url))
            }
        }
        DispatchQueue.main.async { [weak self] in
            guard let self = self else{
                return
            }
            authSession.presentationContextProvider = self
            authSession.prefersEphemeralWebBrowserSession = prefersEphemeralWebBrowserSession
            authSession.start()
        }
    }
    func webAuthAsyncWrapper(parameter: Parameter) async throws -> URL{
        let url = parameter.url
        let callbackURLScheme = parameter.callbackURLScheme
        let prefersEphemeralWebBrowserSession = parameter.prefersEphemeralWebBrowserSession
        return try await withCheckedThrowingContinuation {continuation in
            webAuth(url: url, callbackURLScheme: callbackURLScheme, prefersEphemeralWebBrowserSession: prefersEphemeralWebBrowserSession) { result in
                switch result {
                case .success(let url):
                    continuation.resume(returning: url)
                case .failure(let error):
                    print(error.localizedDescription)
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    public struct Parameter{
        let url: URL
        let callbackURLScheme: String
        let prefersEphemeralWebBrowserSession: Bool
    }
    typealias WebAuthAsyncWrapper = ( Parameter) async throws -> URL
    
    func requestUserInfo<T>(
        parameter: Parameter,
        webAuthAsyncWrapper: @escaping WebAuthAsyncWrapper,
        parseUrlToGetToken: @escaping (URL) async throws->String,
        requestUserInfoByToken: @escaping (String) async throws->T
    ) async throws->T{
        let urlWithTokenInfo = try await webAuthAsyncWrapper(parameter)
        let token = try await parseUrlToGetToken(urlWithTokenInfo)
        let userInfo : T = try await requestUserInfoByToken(token)
        return userInfo
    }
}
