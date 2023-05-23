//
//  TestSpotifyAuth.swift
//  
//
//  Created by MEI YIN LO on 2023/5/22.
//

import XCTest
@testable import UrlRequestFlowFeature
import ComposableArchitecture

final class TestSpotifyAuth: XCTestCase {

    func getTestStore(httpMethod: HttpMethod
                      , runType: RunType
                      , internalParameters: IdentifiedArrayOf<RequestInternalParameterFeature.State>
                      , urlQueryItemKeyValuePairs : IdentifiedArrayOf<KeyPairOfDictionaryUnit>
    )->TestStore<RequestFeature.State, RequestFeature.Action, RequestFeature.State, RequestFeature.Action, ()>{
        let reducer = RequestFeature()
        let uuid = UUID()
        let testStore : TestStore = withDependencies {
            $0.uuid = .incrementing
        } operation: {
            TestStore(initialState:
                        RequestFeature.State(id: uuid
                                             , runType: runType, internalParameters: internalParameters
                                             , httpMethod: httpMethod
                                            , httpBodyKeyValuePairs: [], httpHeadKeyValuePairs: [], urlQueryItemKeyValuePairs: urlQueryItemKeyValuePairs)
                      , reducer: reducer )
        }
        return testStore
    }
    
    func getUrlQueryItemsForSpotifyAuth()->IdentifiedArrayOf<KeyPairOfDictionaryUnit>{
        return IdentifiedArray(uniqueElements: [
            .init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000003" )!
                  , keyOfKey: "client_id_key", keyOfValue: "client_id_value"),
            .init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000006" )!
                  , keyOfKey: "response_type_key", keyOfValue: "response_type_value"),
            .init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000009" )!
                  , keyOfKey: "scope_key", keyOfValue: "scope_value"),
            .init(id: UUID(uuidString: "00000000-0000-0000-0000-00000000000C" )!
                  , keyOfKey: "redirect_uri_key", keyOfValue: "redirect_uri_value")
        ])
    }
    func getInternalParametersForSpotifyAuth()->IdentifiedArrayOf<RequestInternalParameterFeature.State>{
        return IdentifiedArray(uniqueElements: [
            RequestInternalParameterFeature.State.init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000000" )!, key: "urlcomponents_scheme", value: .init(value: "http"))
            ,RequestInternalParameterFeature.State.init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000001" )!, key: "urlcomponents_host", value: .init(value: "accounts.spotify.com"))
            ,RequestInternalParameterFeature.State.init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000002" )!, key: "urlcomponents_path", value: .init(value: "/authorize"))
            ,RequestInternalParameterFeature.State.init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000004" )!, key: "client_id_key", value: .init(value: "client_id"))
            ,RequestInternalParameterFeature.State.init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000005" )!, key: "client_id_value", value: .init(value: CredentitialForTest.spotify.client_id))
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
    @MainActor
    func testAuth()async throws{
        let testStore = getTestStore(httpMethod: .get,runType: .webAuth, internalParameters: getInternalParametersForSpotifyAuth(), urlQueryItemKeyValuePairs: getUrlQueryItemsForSpotifyAuth())
        
        let config : HttpResponseOutputParameterConfiguration = .init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000123")!, reader: .Url(path: .queryItem(key: "code"), outputParameterKey: "code"))
        await testStore.send(.setOutputParameterConfiguration(config)){
            $0.outputParameterConfigurations = IdentifiedArray(uniqueElements: [
                .init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000000" )!
                      , reader: .Url(path: .queryItem(key: "code"), outputParameterKey: "code"))
            ])
            $0.outputParameters = IdentifiedArray(uniqueElements: [
                .init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000001" )!
                      , key: "code", name: "code", value: "")
                ])
        }
        
//        let url = URL(string: "myscheme://myHost/myPath?code=AQDam4exVqZwyLnvvNOUwUeHTpbNRdzpGeY1Z365bLiuTvYzZO6brj1cylHENxcV0MG9Fx2FbuiYH5iBq-tf5CZa008_kNv3I6CJnIDrqlD-F2nYEoH_dX8NNBqWgsk2S-rY65n16KN8RfpnINDzBvVPSCVfAAp6sxv4VgduYdtCNujUXK17hVtIc_kpTPqJtJwarNZ5mbHo4A")!
//        let testResult : TaskResult<URL> = .success(url)
        await testStore.send(.run)
        await testStore.receive(.outputResponseAsUrl(responseUrl: URL(string: "myscheme://myHost/myPath?code=")!))
        await testStore.receive(.outputParameterUpdated)
        
        await testStore.finish(timeout: 1000_000_000_000)
    }
}
