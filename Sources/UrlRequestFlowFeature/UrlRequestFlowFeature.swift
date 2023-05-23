import ComposableArchitecture
import Foundation

public struct UrlRequestFlowFeature: ReducerProtocol{
    @Dependency(\.uuid) var uuid

    public struct State: Equatable, Identifiable{
        public let id: UUID
        public var runningQueue : [UUID]
        public var flowUnits : IdentifiedArrayOf<RequestFeature.State> = []
        public var sharedParameters : IdentifiedArrayOf<SharableParameter> = []
    }
    public enum Action:Equatable{
        case test(String)
        case run([UUID])
        case joinActionFlowUnitFeature(id:RequestFeature.State.ID, action:RequestFeature.Action)
    }
    public var body: some ReducerProtocol<State, Action> {
        Reduce{ state, action in
            switch action{
            case .test(let value):
                print(value)
            case.joinActionFlowUnitFeature(let id, let subAction):
                if (subAction == .outputParameterUpdated) {
                //if case  .outputWithParameter(_) = subAction {
                    state.flowUnits[id: id]?.outputParameters.forEach({outputParameter in
                        let parameterID = state.sharedParameters.first {
                            $0.key == outputParameter.key
                        }!.id
                        state.sharedParameters[id: parameterID]!.value = outputParameter.value
                    })
                    let idsToUpdate = state.flowUnits.map {
                        $0.id
                    }
                    idsToUpdate.forEach {
                        state.flowUnits[id: $0]!.inputParameters = state.sharedParameters
                    }
                    if state.runningQueue.count == 0{return .none}
                    return .send(.run(state.runningQueue))
                }
            case .run(var queue):
                if queue.count == 0{return .none}
                let first = queue.removeFirst()
                state.runningQueue = queue
                //state.flowUnits[id: first]!
                return .send(.joinActionFlowUnitFeature(id: first, action: .run))
            }
        
            return .none
        }
        .forEach(\.flowUnits, action: /Action.joinActionFlowUnitFeature) {
            RequestFeature()
        }
    }
}
