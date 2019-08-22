//
//  EditNotePresenter.swift
//  ReduxNotes
//
//  Created by Dima Osadchy on 15/08/2019.
//  Copyright © 2019 Alexey Demedeckiy. All rights reserved.
//

extension Actions.Notes {
    struct UpdateNote: Action {
        let note: Note
        let noteId: AllNotes.Id
    }
}

struct EditNotePresenter {
    typealias Props = NewNoteViewController.Props
    
    let noteId: AllNotes.Id
    let render: CommandWith<Props>
    let dispatch: CommandWith<Action>
    let endObserving: Command
    
    
    func present(state: State) {
        guard let note = state.allNotes.byId[noteId] else {
            fatalError("cannot display note for ID: \(noteId)")
        }
        
        var editNoteText = note.text
        
        let props = Props(
            title: "Edit Note",
            text: note.text,
            updateText: CommandWith { editNoteText = $0 },
            cancel: dispatch.bind(to: Actions.Notes.ClearNewNote()),
            save: Command {
                self.dispatch.perform(with: Actions.Notes.UpdateNote(note: Note(text: editNoteText, context: note.context), noteId: self.noteId))
                self.dispatch.perform(with: Actions.Notes.ClearNewNote())
            },
            endObserving: Command { self.endObserving.perform() }
        )
        
        render.perform(with: props)
    }
}
