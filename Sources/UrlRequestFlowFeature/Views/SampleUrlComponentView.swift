//
//  SwiftUIView.swift
//  
//
//  Created by MEI YIN LO on 2023/5/27.
//

import SwiftUI
import ComposableArchitecture

struct SampleKeyPairOfDictionaryUnitView: View{
    let store: StoreOf<KeyPairOfDictionaryUnitFeature>
    let internalParameters : IdentifiedArrayOf<RequestInternalParameterFeature.State>
    let sharedParameters: IdentifiedArrayOf<SharableParameter>
    
    func getElementView(viewStore: ViewStoreOf<KeyPairOfDictionaryUnitFeature>,   action: KeyPairOfDictionaryUnitFeature.Action, prompt: String)->some View{
        switch action {
        case .setKeyOfKey(var composableParameter),.setKeyOfValue(var composableParameter):
            let internalParameter = internalParameters.first {
                $0.key == composableParameter.key
            }
            return Picker(selection: viewStore.binding(get: {_ in internalParameter?.value.lookupKey ?? ""}, send: {
                composableParameter.value.lookupKey = $0
                let updatedAction = action.updateParameter(parameter: composableParameter)
                return updatedAction
            })) {
                Text("").tag("")
                ForEach(sharedParameters) {
                    Text($0.name).tag($0.key)
                }
            } label: {
                //EmptyView()
                TextField(
                    (internalParameter?.value.lookupKey == nil) ? prompt : ""
                    , text: viewStore.binding(
                        get:{_ in
                            if (internalParameter?.value.lookupKey?.count ?? 0) > 0
                            {return ""}
                            else{
                                return (internalParameter?.value.value ?? "")
    
                            }
    
    
                        }
                        ,send:{
                            composableParameter.value.value = $0
                            let updatedAction = action.updateParameter(parameter: composableParameter)
                            return updatedAction
                        }))
            }
        }
        
    }
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            HStack{
                getElementView(viewStore: viewStore, action: .setKeyOfKey(.init(id: viewStore.id, key: viewStore.keyOfKey, value: .init(value: ""))), prompt: "name")
                Spacer()
                getElementView(viewStore: viewStore, action: .setKeyOfValue(.init(id: viewStore.id, key: viewStore.keyOfValue, value: .init(value: ""))), prompt: "value")
//                TextField("name", text: viewStore.binding(get: {_ in
//                    return ComposableParameter.getParameterValueByKey(key: viewStore.keyOfKey, from: internalParameters, lookup: sharedParameters)!
//                }, send: {
//                    return KeyPairOfDictionaryUnitFeature.Action.setKeyOfKey(.init(id: viewStore.id, key: viewStore.keyOfKey, value: .init(value: $0)))
//                } ))
//                Spacer()
//                TextField("value", text: viewStore.binding(get: {_ in
//                    return ComposableParameter.getParameterValueByKey(key: viewStore.keyOfValue, from: internalParameters, lookup: sharedParameters)!
//                }, send: {
//                    return KeyPairOfDictionaryUnitFeature.Action.setKeyOfKey(.init(id: viewStore.id, key: viewStore.keyOfValue, value: .init(value: $0)))
//                } ))
            }
        }
    }
}
struct SampleSharableParameterView: View{
    let store : StoreOf<SharableParameterFeature>
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            HStack{
                Text(viewStore.key)
                TextField("name", text: viewStore.binding(get: \.name, send: SharableParameterFeature.Action.setName ))
                Spacer()
                TextField("value", text: viewStore.binding(get: \.value, send: SharableParameterFeature.Action.setValue ))
            }
        }
    }
}
struct SampleUrlComponentView: View {
    let store : StoreOf<RequestFeature>
    
    
    func getSection(viewStore: ViewStoreOf<RequestFeature>,title: String, prompt: String, setKey: HttpParameterKey)->some View{
       
        return Section(title) {
            let internalParameter = viewStore.internalParameters.first {
                $0.key == setKey.rawValue
            }
            Picker(selection: viewStore.binding(get: {_ in internalParameter?.value.lookupKey ?? ""}, send: {
                RequestFeature.Action.setUrlComponentByParameterKey(setKey, $0)
            })) {
                Text("").tag("")
                ForEach(viewStore.inputParameters) {
                    Text($0.name).tag($0.key)
                }
            } label: {
                TextField(
                    (internalParameter?.value.lookupKey == nil) ? prompt : ""
                    , text: viewStore.binding(
                        get:{_ in
                            if (internalParameter?.value.lookupKey?.count ?? 0) > 0
                            {return ""}
                            else{
                                return (internalParameter?.value.value ?? "")
                                
                            }
                            
                            
                        }
                        ,send:{
                            RequestFeature.Action.setUrlComponent(setKey, $0)}))
            }

        }
    }
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            Form{
                Text(viewStore.urlcomponents.url?.absoluteString ?? "")
                getSection(viewStore: viewStore, title: "Scheme", prompt: "http", setKey: .urlcomponents_scheme)
                getSection(viewStore: viewStore, title: "Host", prompt: "www.example.com", setKey: .urlcomponents_host)
                getSection(viewStore: viewStore, title: "Port", prompt: "", setKey: .urlcomponents_port)
                getSection(viewStore: viewStore, title: "Path", prompt: "/", setKey: .urlcomponents_path)
                Section("Query Items") {
                                        Button {
                                            viewStore.send(.addUrlComponentQueryItem(.init(id: UUID(), key: UUID().uuidString, value: .init(value: "")), .init(id: UUID(), key: UUID().uuidString, value: .init(value: ""))))
                                        } label: {
                                            HStack{
                                                Spacer()
                                                Text("+")
                                                Spacer()
                                            }
                                        }
                    ForEachStore(store.scope(state: \.urlQueryItemKeyValuePairs, action: RequestFeature.Action.joinActionUrlComponentQueryItem)) {
                        SampleKeyPairOfDictionaryUnitView(store: $0, internalParameters: viewStore.internalParameters, sharedParameters: viewStore.inputParameters)
                    }
                }
                Section("internal Parameters"){
                    ForEach(viewStore.internalParameters, id:\.id){item in
                        HStack{
                            Text(item.key)
                            Text(item.value.value)
                            Text(item.value.lookupKey ?? "")
                        }
                    }
                    EmptyView()
                }
                Section("input Parameters") {


                    ForEachStore(store.scope(state: \.inputParameters , action: RequestFeature.Action.joinActionSharableParameterFeature), content: {SampleSharableParameterView(store: $0)})
                }
                
            }
        }
    }
}

struct SampleUrlComponentView_Previews: PreviewProvider {
    static var inputParameters: IdentifiedArrayOf<SharableParameter>{
        let http: SharableParameter = .init(id: UUID(), key: "http", name: "http", value: "http")
        let test: SharableParameter = .init(id: UUID(), key: "test", name: "test", value: "test1234")
        return IdentifiedArrayOf(uniqueElements: [
            http,
            test
        ])
    }
    static var store : StoreOf<RequestFeature> {
        return .init(initialState: .init(id: UUID(), runType: .urlRequest
                                         ,inputParameters : inputParameters
                                        ) , reducer: RequestFeature())
    }
    static var previews: some View {
        SampleUrlComponentView(store: store)
    }
}
