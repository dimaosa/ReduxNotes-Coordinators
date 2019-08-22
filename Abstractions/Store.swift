/*







*/

import Foundation

typealias Dispatch = (Action) -> ()
typealias Middleware<State> = (@escaping Dispatch, @escaping () -> State, @escaping Dispatch) -> Dispatch

typealias Reducer<State> = (State, Action) -> State
final class Store<State> {
    
    // Current AppState of the whole app
    private(set) var state: State
    
    private let reducer: Reducer<State>
    
    // API calls, managers and etc are handled via Middleware
    private let middleware: [Middleware<State>]
    
    private var dispatch: Dispatch?
    
    // Store has own queue where all mutation is peformed
    private let queue = DispatchQueue(label: "com.redux.store")
    
    // All subscibers of state changes
    private var subscribers: Set<CommandWith<State>> = []

    init(state: State, middleware: [Middleware<State>], reducer: @escaping (State, Action) -> State) {
        self.state = state
        self.reducer = reducer
        self.middleware = middleware
        
        let initial = { (action: Action) in
            self.state = self.reducer(self.state, action)
            self.subscribers.forEach { $0.perform(with: self.state) }
        }
        
        self.dispatch = middleware
            .reversed()
            .reduce(initial) { (result, next) in
                return next(self.dispatch, { self.state }, result)
            }
    }

    func dispatch(action: Action) {
        queue.async {
            self.dispatch?(action)
        }
    }
    
    // Observable Store will return a command which is used to stop observing
    @discardableResult
    func observe(with command: CommandWith<State>) -> Command {
        queue.async {
            self.subscribers.insert(command)
            command.perform(with: self.state)
        }
        
        command.perform(with: state)
        // Cancel observing should not keep a link to command, so we need to use `weak` here
        let endObserving = Command(id: "Dispose observing for \(command)") { [weak command] in
            guard let command = command else { return }
            self.subscribers.remove(command)
            }.dispatched(on: queue)
        
        // `queue` is a serial block, so add observing will always be performed
        // before end observing
        
        return endObserving
    }
}

final class StoreLocator {
    static var shared: Store<State>!
    
    class func register(store: Store<State>) {
        shared = store
    }
}
