//
//  ControllerFactory.swift
//  ReduxNotes
//
//  Created by Dima Osadchy on 15/08/2019.
//  Copyright © 2019 Alexey Demedeckiy. All rights reserved.
//

import Foundation

final class ControllerFactory {
    private let store: Store<State>
    
    init(store: Store<State> = StoreLocator.shared) {
        self.store = store
    }
    
    func startLocation() {
        let controller = LocationController()
        
        let presenter = LocationPresenter(
            render: CommandWith { [weak controller] props in controller?.render(props: props)},
            dispatch: CommandWith(action: store.dispatch))
        
        store.observe(with: CommandWith(action: presenter.present))
    }
    
    func startFirebase() {
        let controller = FirebaseController()
        
        let presenter = FirebasePresenter(
            render: CommandWith { [weak controller] props in controller?.render(props: props)},
            dispatch: CommandWith(action: store.dispatch))
        
        store.observe(with: CommandWith(action: presenter.present))
    }
}
