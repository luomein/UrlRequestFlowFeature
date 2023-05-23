//
//  File.swift
//  
//
//  Created by MEI YIN LO on 2023/5/22.
//

import Foundation
import ComposableArchitecture

extension RequestFeature: ReducerProtocol{
    
    public var body: some ReducerProtocol<State, Action> {
        Reduce{ state, action in
            switch action{
            case .outputParameterUpdated:
                break
            
            case .setUrlComponent(let parameter, let value):
                state.internalParameters.append(.init(id: uuid(), key: parameter.rawValue, value: .init(value: value)))
            case .setOutputParameterConfiguration(let value):
                state.outputParameterConfigurations.append(.init(id: uuid()
                                                                 , reader:value.reader))
                switch value.reader{
                case .Url(_, let key),.JsonDict(_, let key):
                    state.outputParameters.append(.init(id: uuid(), key: key, name: key, value: ""))

                }

            case .setUrlComponentQueryItem(let key, let value):
                state.urlQueryItemKeyValuePairs.append(.init(id: uuid(), keyOfKey: key.key, keyOfValue: value.key))
                state.internalParameters.append(.init(id: uuid(), key: key.key, value: key.value))
                state.internalParameters.append(.init(id: uuid(), key: value.key, value: value.value))
            case .setHttpMethod(let value):
                state.httpMethod = value
            case .setHttpBody(let key, let value):
                state.httpBodyKeyValuePairs.append(.init(id: uuid(), keyOfKey: key.key, keyOfValue: value.key))
                state.internalParameters.append(.init(id: uuid(), key: key.key, value: key.value))
                state.internalParameters.append(.init(id: uuid(), key: value.key, value: value.value))
            case .setHttpHead(let key, let value):
                state.httpHeadKeyValuePairs.append(.init(id: uuid(), keyOfKey: key.key, keyOfValue: value.key))
                state.internalParameters.append(.init(id: uuid(), key: key.key, value: key.value))
                state.internalParameters.append(.init(id: uuid(), key: value.key, value: value.value))
            case .outputResponseAsUrl(let responseUrl):
                print("responseUrl: ",responseUrl)
                //let responseUrl = try! taskResult.value
                state.outputParameters = []
                state.outputParameterConfigurations.forEach { config in
                    if case let .Url(path, outputParameterKey) = config.reader{
                        let value = path.getUrlComponentsValueByKey(urlcomonents: URLComponents(url: responseUrl, resolvingAgainstBaseURL: false)!)!
                        state.outputParameters.append(.init(id: uuid(), key: outputParameterKey, name: outputParameterKey, value: value))
                    }
                }
                return .send(.outputParameterUpdated)
            case .outuptResponseAsData(let data):
                state.outputParameters = []
                switch state.httpResponseType{
                case .JsonDict:
                    if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        state.outputParameterConfigurations.forEach { config in
                            if case let .JsonDict(dictKey, outputParameterKey) = config.reader{
                                if let value = json[dictKey]{
                                    let str = String(describing: value)
                                    state.outputParameters.append(.init(id: uuid(), key: outputParameterKey, name: outputParameterKey, value: str))
                                }
                            }
                        }
                    }
                default:
                    fatalError()

                }
                return .send(.outputParameterUpdated)
            case .run:
                switch state.runType{
                case .webAuth:
                    return .run { [state] send in
                        //let auth = OAuth2AsyncManager()
                        let parameter = state.oathParameter
                            //await send(.receivedResponse(TaskResult { try await self.fetch() }))
                        await send(.outputResponseAsUrl(responseUrl: try! TaskResult{try await //auth.webAuthAsyncWrapper(parameter: parameter)
                            oauth2DependencyManager.fetch(parameter)
                        }.value))
                          }
                case .urlRequest:
                    return .run {[state] send in
                        await send(.outuptResponseAsData(try! TaskResult{try! await sendHttpRequest(request: state.httpRequest)}.value))
                        //try await sendHttpRequest(request: state.httpRequest)
                    }
                }
            default:
                fatalError()
            }
            return .none
        }
    }
}
