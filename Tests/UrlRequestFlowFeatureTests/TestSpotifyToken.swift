//
//  TestSpotifyToken.swift
//  
//
//  Created by MEI YIN LO on 2023/5/22.
//

import XCTest
@testable import UrlRequestFlowFeature
import ComposableArchitecture


final class TestSpotifyToken: XCTestCase {

    func getTestStore()->TestStore<UrlRequestFlowFeature.State, UrlRequestFlowFeature.Action, UrlRequestFlowFeature.State, UrlRequestFlowFeature.Action, ()>{
        let uuid = UUID()
        let sharedParameters :IdentifiedArrayOf<SharableParameter> = IdentifiedArrayOf(uniqueElements: [
            .init(id: UUID(uuidString: "00000000-0000-0000-0000-0000000000b1" )!
                  , key:"code"
                  , name: "code", value: "")
        ])
        let testStore : TestStore = withDependencies {
            $0.uuid = .incrementing
        } operation: {
            TestStore(initialState:
                        UrlRequestFlowFeature.State(id: uuid
                                          , runningQueue: []
                                          ,flowUnits: IdentifiedArrayOf(uniqueElements: [
                                            getSpotifyAuthUnit(sharedParameters: sharedParameters)
                                            ,getSpotifyTokenUnit(sharedParameters: sharedParameters)
                                          ])
                                          ,sharedParameters: sharedParameters
                                         )
                      , reducer: UrlRequestFlowFeature() )
        }
        
        return testStore
    }
    func getInternalParametersForSpotifyAuth()->IdentifiedArrayOf<RequestInternalParameterFeature.State>{
        return IdentifiedArray(uniqueElements: [
            RequestInternalParameterFeature.State.init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000000" )!, key: "urlcomponents_scheme", value: .init(value: "http"))
            ,RequestInternalParameterFeature.State.init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000001" )!, key: "urlcomponents_host", value: .init(value: "accounts.spotify.com"))
            ,RequestInternalParameterFeature.State.init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000002" )!, key: "urlcomponents_path", value: .init(value: "/authorize"))
            ,RequestInternalParameterFeature.State.init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000004" )!, key: "client_id_key", value: .init(value: "client_id"))
            ,RequestInternalParameterFeature.State.init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000005" )!, key: "client_id_value", value: .init(value: CredentitialForTest.spotify.client_id ))
            ,RequestInternalParameterFeature.State.init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000007" )!, key: "response_type_key", value: .init(value: "response_type"))
            ,RequestInternalParameterFeature.State.init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000008" )!, key: "response_type_value", value: .init(value: "code"))
            ,RequestInternalParameterFeature.State.init(id: UUID(uuidString: "00000000-0000-0000-0000-00000000000A" )!, key: "scope_key", value: .init(value: "scope"))
            ,RequestInternalParameterFeature.State.init(id: UUID(uuidString: "00000000-0000-0000-0000-00000000000B" )!, key: "scope_value", value: .init(value: "streaming user-read-private"))
            ,RequestInternalParameterFeature.State.init(id: UUID(uuidString: "00000000-0000-0000-0000-00000000000D" )!, key: "redirect_uri_key", value: .init(value: "redirect_uri"))
            ,RequestInternalParameterFeature.State.init(id: UUID(uuidString: "00000000-0000-0000-0000-00000000000E" )!, key: "redirect_uri_value", value: .init(value: "myScheme://myHost/myPath"))
            ,RequestInternalParameterFeature.State.init(id: UUID(uuidString: "00000000-0000-0000-0000-00000000000F" )!, key: "webauth_prefersEphemeralWebBrowserSession", value: .init(value: "false"))
            ,RequestInternalParameterFeature.State.init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000010" )!, key: "webauth_callbackURLScheme", value: .init(value: "myScheme"))
        ])
    }
    func getSpotifyAuthUnit(sharedParameters: IdentifiedArrayOf<SharableParameter>)->RequestFeature.State{
        return .init(id: UUID(uuidString: "00000000-0000-0000-0000-0000000000a1" )!, runType: .webAuth, internalParameters: getInternalParametersForSpotifyAuth()
                     , inputParameters: sharedParameters
                     , outputParameterConfigurations: IdentifiedArray(uniqueElements: [
                       .init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000000" )!
                             , reader: .Url(path: .queryItem(key: "code"), outputParameterKey: "code"))
                   ])
                     , httpMethod: nil
                     , httpBodyKeyValuePairs: [], httpHeadKeyValuePairs: []
                     , urlQueryItemKeyValuePairs: IdentifiedArray(uniqueElements: [
                        .init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000003" )!
                              , keyOfKey: "client_id_key", keyOfValue: "client_id_value"),
                        .init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000006" )!
                              , keyOfKey: "response_type_key", keyOfValue: "response_type_value"),
                        .init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000009" )!
                              , keyOfKey: "scope_key", keyOfValue: "scope_value"),
                        .init(id: UUID(uuidString: "00000000-0000-0000-0000-00000000000C" )!
                              , keyOfKey: "redirect_uri_key", keyOfValue: "redirect_uri_value")
                    ]))
    }
    func getInternalParametersForSpotifyToken()->IdentifiedArrayOf<RequestInternalParameterFeature.State>{
        let clientSecret = CredentitialForTest.spotify.client_secret
        let clientId =  CredentitialForTest.spotify.client_id
        return IdentifiedArray(uniqueElements: [
            RequestInternalParameterFeature.State.init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000000" )!, key: "urlcomponents_scheme", value: .init(value: "https"))
            ,RequestInternalParameterFeature.State.init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000001" )!, key: "urlcomponents_host", value: .init(value: "accounts.spotify.com"))
            ,RequestInternalParameterFeature.State.init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000002" )!, key: "urlcomponents_path", value: .init(value: "/api/token"))
            ,RequestInternalParameterFeature.State.init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000004" )!, key: "client_id_key", value: .init(value: "client_id"))
            ,RequestInternalParameterFeature.State.init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000005" )!, key: "client_id_value", value: .init(value: CredentitialForTest.spotify.client_id))
            ,RequestInternalParameterFeature.State.init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000007" )!, key: "response_type_key", value: .init(value: "response_type"))
            ,RequestInternalParameterFeature.State.init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000008" )!, key: "response_type_value", value: .init(value: "code"))
            ,RequestInternalParameterFeature.State.init(id: UUID(uuidString: "00000000-0000-0000-0000-00000000000A" )!, key: "scope_key", value: .init(value: "scope"))
            ,RequestInternalParameterFeature.State.init(id: UUID(uuidString: "00000000-0000-0000-0000-00000000000B" )!, key: "scope_value", value: .init(value: "streaming user-read-private"))
            ,RequestInternalParameterFeature.State.init(id: UUID(uuidString: "00000000-0000-0000-0000-00000000000D" )!, key: "redirect_uri_key", value: .init(value: "redirect_uri"))
            ,RequestInternalParameterFeature.State.init(id: UUID(uuidString: "00000000-0000-0000-0000-00000000000E" )!, key: "redirect_uri_value", value: .init(value: "myScheme://myHost/myPath"))
            
            ,RequestInternalParameterFeature.State.init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000010" )!, key: "http_body_key_code", value: .init(value: "code"))
            ,RequestInternalParameterFeature.State.init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000011" )!, key: "http_body_value_code", value: .init(value: "",lookupKey: "code"))
            ,RequestInternalParameterFeature.State.init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000012" )!, key: "http_body_key_grant_type", value: .init(value: "grant_type"))
            ,RequestInternalParameterFeature.State.init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000013" )!, key: "http_body_value_grant_type", value: .init(value: "authorization_code"))
            
            ,RequestInternalParameterFeature.State.init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000020" )!, key: "http_head_key_authorization", value: .init(value: "Authorization"))
            ,RequestInternalParameterFeature.State.init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000021" )!, key: "http_head_value_authorization", value: .init(value: "Basic \("\(clientId):\(clientSecret)".toBase64())"))
        ])
    }
    func getSpotifyTokenUnit(sharedParameters: IdentifiedArrayOf<SharableParameter>)->RequestFeature.State{
        return .init(id: UUID(uuidString: "00000000-0000-0000-0000-0000000000a2" )!, runType: .urlRequest, internalParameters: getInternalParametersForSpotifyToken()
                     , inputParameters: sharedParameters
                     , outputParameterConfigurations: IdentifiedArray(uniqueElements: [
//                       .init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000000" )!
//                             , reader: .Url(path: .queryItem(key: "code"), outputParameterKey: "code"))
                   ])
                     , httpMethod: .post
                     , httpBodyKeyValuePairs: IdentifiedArray(uniqueElements: [
                        .init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000000" )!, keyOfKey: "http_body_key_code", keyOfValue: "http_body_value_code")
                        ,.init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000001" )!, keyOfKey: "http_body_key_grant_type", keyOfValue: "http_body_value_grant_type")
                        ,.init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000002" )!, keyOfKey: "client_id_key", keyOfValue: "client_id_value")
                        ,.init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000003" )!, keyOfKey: "redirect_uri_key", keyOfValue: "redirect_uri_value")
                        ])
                     , httpHeadKeyValuePairs: IdentifiedArray(uniqueElements: [
                        .init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000000" )!, keyOfKey: "http_head_key_authorization", keyOfValue: "http_head_value_authorization")
                        ])
                     , urlQueryItemKeyValuePairs: [])
    }
    
    @MainActor
    func test()async throws{
        let testStore = getTestStore()
        
        let code = "AQDam4exVqZwyLnvvNOUwUeHTpbNRdzpGeY1Z365bLiuTvYzZO6brj1cylHENxcV0MG9Fx2FbuiYH5iBq-tf5CZa008_kNv3I6CJnIDrqlD-F2nYEoH_dX8NNBqWgsk2S-rY65n16KN8RfpnINDzBvVPSCVfAAp6sxv4VgduYdtCNujUXK17hVtIc_kpTPqJtJwarNZ5mbHo4A"
        let path = "myscheme://myHost/myPath?code="
        testStore.dependencies.oauth2DependencyManager = .getOAuth2DependencyManager(path: path, code: code)
        
        await testStore.send(.run([
            UUID(uuidString: "00000000-0000-0000-0000-0000000000a1" )!
            ,UUID(uuidString: "00000000-0000-0000-0000-0000000000a2" )!
        ]))
        {
            $0.runningQueue = [UUID(uuidString: "00000000-0000-0000-0000-0000000000a2" )!]
        }
        await testStore.receive(UrlRequestFlowFeature.Action.joinActionFlowUnitFeature(id: UUID(uuidString: "00000000-0000-0000-0000-0000000000a1" )!, action: .run))
        
        
        let url = URL(string: "\(path)\(code)")!
        
        
//
        await testStore.receive(UrlRequestFlowFeature.Action.joinActionFlowUnitFeature(id: UUID(uuidString: "00000000-0000-0000-0000-0000000000a1" )!, action: .outputResponseAsUrl(responseUrl: url) )){
            $0.flowUnits[id: UUID(uuidString: "00000000-0000-0000-0000-0000000000a1" )!]?.outputParameters = IdentifiedArrayOf(uniqueElements: [
                .init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000000" )!, key: "code", name: "code", value: code)
            ])
        }
        
        await testStore.receive(UrlRequestFlowFeature.Action.joinActionFlowUnitFeature(id: UUID(uuidString: "00000000-0000-0000-0000-0000000000a1" )!, action: .outputParameterUpdated )){
            $0.flowUnits[id: UUID(uuidString: "00000000-0000-0000-0000-0000000000a1" )!]?.inputParameters = IdentifiedArrayOf(uniqueElements: [
                .init(id: UUID(uuidString: "00000000-0000-0000-0000-0000000000b1" )!, key: "code", name: "code", value: code)
            ])
            $0.flowUnits[id: UUID(uuidString: "00000000-0000-0000-0000-0000000000a2" )!]?.inputParameters = IdentifiedArrayOf(uniqueElements: [
                .init(id: UUID(uuidString: "00000000-0000-0000-0000-0000000000b1" )!, key: "code", name: "code", value: code)
            ])
            
            $0.sharedParameters = IdentifiedArrayOf(uniqueElements: [
                .init(id: UUID(uuidString: "00000000-0000-0000-0000-0000000000b1" )!, key: "code", name: "code", value: code)
            ])
        }
        await testStore.receive(.run([
            UUID(uuidString: "00000000-0000-0000-0000-0000000000a2" )!
        ])){
            $0.runningQueue = []
        }
        await testStore.receive(UrlRequestFlowFeature.Action.joinActionFlowUnitFeature(id: UUID(uuidString: "00000000-0000-0000-0000-0000000000a2" )!, action: .run))
        
        await testStore.finish(timeout: 1000_000_000_000)
        
        //{"access_token":"BQDEKF_N8fU3sz6wtc9euFCMY8C_lIm139dYpDYilxvG0-TxbQ9oG82bpFBKmkEYr36H2cRoPLLyY84jwW8yMMM30W9cxcDDeFZKngKHd-QRU3VATW0Doj2G_Fb7_QGZzWyFC6jPZgMGzwN4X6SxBtCWmsZ3DONQHV0Ft3TBqayHGlP-mV_99yXTHAdpLpZ8","token_type":"Bearer","expires_in":3600,"refresh_token":"AQDQTgOafpL3ebXSMJWZhtR8bKaM0zInZHHuoZswAVxP4n9B0RH6uyWWhjSND871q_aUBwLYO1yokCXo1uozMSClPcc5Lc7xqmw7Qd6ggo752j6RvwLPhj5dhDJkyfy-1HQ","scope":"streaming user-read-private"}
    }
}
