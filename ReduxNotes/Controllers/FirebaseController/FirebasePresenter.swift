//
//  FirebasePresenter.swift
//  ReduxNotes
//
//  Created by Dima Osadchy on 15/08/2019.
//  Copyright © 2019 Alexey Demedeckiy. All rights reserved.
//

import Foundation

struct FirebasePresenter {
    typealias Props = FirebaseController.Props
    
    let render: CommandWith<Props>
    let dispatch: CommandWith<Action>
    
    func present(state: State) {
        render.perform(with: Props(
            updateCommonNotes: dispatch.map(transform: Actions.Notes.UpdateCommonNotes.init),
            commonNotes: state.allNotes.byId.filter({ $0.value.context == .common })))
    }
}
