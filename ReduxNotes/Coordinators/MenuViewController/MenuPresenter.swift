//
//  MenuPresenter.swift
//  ReduxNotes
//
//  Created by Dima Osadchy on 12/08/2019.
//  Copyright © 2019 Alexey Demedeckiy. All rights reserved.
//

extension Actions {
    enum Menu {
        struct PersonalNotesTabSelectedAction: Action {}
        
        struct CommonNotesTabSelectedAction: Action {}
    }

}

struct MenuPresenter {
    typealias Props = MenuTabBarViewController.Props
    
    let render: CommandWith<Props>
    let dispatch: CommandWith<Action>
    let endObserving: Command
    
    func present(state: State) {
        render.perform(with: Props(
            personalNote: dispatch.bind(to: Actions.Menu.PersonalNotesTabSelectedAction()),
            commonNotes: dispatch.bind(to: Actions.Menu.CommonNotesTabSelectedAction()),
            endObserving: endObserving
        ))
    }
}
