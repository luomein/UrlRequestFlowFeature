//
//  File.swift
//  
//
//  Created by MEI YIN LO on 2023/5/22.
//

import Foundation
import ComposableArchitecture

public struct RequestFeature{
    @Dependency(\.uuid) var uuid
    @Dependency(\.oauth2DependencyManager) var oauth2DependencyManager
    
    public init(){
        
    }
    
    public struct State: Equatable, Identifiable{
        public var id: UUID
        public var runType : RunType
        
        public init(id: UUID, runType: RunType
                    ,internalParameters : IdentifiedArrayOf<RequestInternalParameterFeature.State> = []
                    
                    ,inputParameters: IdentifiedArrayOf<SharableParameter> = []
                    ,outputParameters: IdentifiedArrayOf<SharableParameter> = []
                    ,outputParameterConfigurations: IdentifiedArrayOf<HttpResponseOutputParameterConfiguration> = []
                    
                    ,httpMethod : HttpMethod? = nil
                    ,httpBodyKeyValuePairs : IdentifiedArrayOf<KeyPairOfDictionaryUnit> = []
                    ,httpHeadKeyValuePairs : IdentifiedArrayOf<KeyPairOfDictionaryUnit> = []
                    ,urlQueryItemKeyValuePairs : IdentifiedArrayOf<KeyPairOfDictionaryUnit> = []
        ) {
            self.id = id
            self.runType = runType
            self.internalParameters = internalParameters
            
            self.inputParameters = inputParameters
            self.outputParameters = outputParameters
            self.outputParameterConfigurations = outputParameterConfigurations
            
            self.httpMethod = httpMethod
            self.httpBodyKeyValuePairs = httpBodyKeyValuePairs
            self.httpHeadKeyValuePairs = httpHeadKeyValuePairs
            self.urlQueryItemKeyValuePairs = urlQueryItemKeyValuePairs
        }
//        RequestFeature.State(id: uuid
//                             , runType: runType, internalParameters: internalParameters
//                             , httpMethod: httpMethod
//                            , httpBodyKeyValuePairs: [], httpHeadKeyValuePairs: [], urlQueryItemKeyValuePairs: urlQueryItemKeyValuePairs)
        
        public var internalParameters: IdentifiedArrayOf<RequestInternalParameterFeature.State> = []
        public var inputParameters: IdentifiedArrayOf<SharableParameter> = []
        public var outputParameters: IdentifiedArrayOf<SharableParameter> = []
        public var outputParameterConfigurations: IdentifiedArrayOf<HttpResponseOutputParameterConfiguration> = []
        
        public var httpBodyContentType: HttpBodyContentType = .dict
        public var httpBodyContentEncoding : String.Encoding = .utf8
        public var httpMethod : HttpMethod?
        public var httpResponseType : HttpResponseType = .JsonDict
        
        public var httpBodyKeyValuePairs : IdentifiedArrayOf<KeyPairOfDictionaryUnit> = []
        public var httpHeadKeyValuePairs : IdentifiedArrayOf<KeyPairOfDictionaryUnit> = []
        public var urlQueryItemKeyValuePairs : IdentifiedArrayOf<KeyPairOfDictionaryUnit> = []
    }
}

