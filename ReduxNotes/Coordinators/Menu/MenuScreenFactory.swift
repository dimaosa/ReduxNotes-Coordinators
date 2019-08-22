//
//  MenuScreenFactory.swift
//  ReduxNotes
//
//  Created by Dima Osadchy on 13/08/2019.
//  Copyright © 2019 Alexey Demedeckiy. All rights reserved.
//

import UIKit

final class MenuScreenFactory {
    private let store: Store<State>
    
    init(store: Store<State> = StoreLocator.shared) {
        self.store = store
    }
    
    func mainMenu() -> UIViewController {
        let viewController = MenuTabBarViewController(nibName: nil, bundle: nil)
        var cancelObserving: Command?
        
        let presenter = MenuPresenter(
            render: CommandWith { [weak viewController] props in
                viewController?.render(props: props)
                }.dispatched(on: .main),
            dispatch: CommandWith(action: store.dispatch),
            endObserving: Command { cancelObserving?.perform()
        })
        
        cancelObserving = store.observe(with: CommandWith(action: presenter.present))
        return viewController
    }
    
    func personalNotes() -> AllNotesTableViewController {
        let viewController = AllNotesTableViewController(nibName: nil, bundle: nil)
        var cancelObserving: Command?
        
        let presenter = PersonalNotesTablePresenter(
            render: CommandWith { [weak viewController] props in
                viewController?.render(props: props)
                }.dispatched(on: .main),
            dispatch: CommandWith(action: store.dispatch),
            endObserving: Command { cancelObserving?.perform() }
        )
        
        cancelObserving = store.observe(with: CommandWith(action: presenter.present))
        return viewController
    }
    
    func commonNotes() -> AllNotesTableViewController {
        let viewController = AllNotesTableViewController(nibName: nil, bundle: nil)
        var cancelObserving: Command?
        
        let presenter = CommonNotesTablePresenter(
            render: CommandWith { [weak viewController] props in
                viewController?.render(props: props)
                }.dispatched(on: .main),
            dispatch: CommandWith(action: store.dispatch),
            endObserving: Command { cancelObserving?.perform() }
        )
        
        cancelObserving = store.observe(with: CommandWith(action: presenter.present))
        return viewController
    }
    
    func connectDetails(noteID: AllNotes.Id) -> NoteDetailsViewController {
        let viewController = NoteDetailsViewController(nibName: nil, bundle: nil)
        var cancelObserving: Command?
        
        let presenter = NoteDetailsPresenter(
            noteID: noteID,
            render: CommandWith { [weak viewController] props in
                viewController?.render(props: props)
                }.dispatched(on: .main),
            dispatch: CommandWith(action: store.dispatch),
            endObserving: Command { cancelObserving?.perform() }
        )
        
        cancelObserving = store.observe(with: CommandWith(action: presenter.present))
        return viewController
    }
    
    func newNote(context: NewNotePresenter.Context) -> NewNoteViewController {
        let viewController = NewNoteViewController(nibName: nil, bundle: nil)
        var cancelObserving: Command?
        
        let presenter = NewNotePresenter(
            render: CommandWith { [weak viewController] props in
                viewController?.render(props: props
            )}.dispatched(on: .main),
            dispatch: CommandWith(action: store.dispatch),
            endObserving: Command { cancelObserving?.perform() },
            context: context)
        
        cancelObserving = store.observe(with: CommandWith(action: presenter.present))
        return viewController
    }
    
    func editNote(noteId: AllNotes.Id) -> NewNoteViewController {
        let viewController = NewNoteViewController(nibName: nil, bundle: nil)
        var cancelObserving: Command?
        
        let presenter = EditNotePresenter(
            noteId: noteId,
            render: CommandWith { [weak viewController] props in
                viewController?.render(props: props
                )}.dispatched(on: .main),
            dispatch: CommandWith(action: store.dispatch),
            endObserving: Command { cancelObserving?.perform() })
        
        cancelObserving = store.observe(with: CommandWith(action: presenter.present))
        return viewController
    }
}
