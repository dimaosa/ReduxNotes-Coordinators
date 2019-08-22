extension Actions.NotesView {
    struct Edit: Action {
        let noteId: AllNotes.Id
    }
}


struct NoteDetailsPresenter {
    typealias Props = NoteDetailsViewController.Props
    
    let noteID: AllNotes.Id
    let render: CommandWith<Props>
    let dispatch: CommandWith<Action>
    let endObserving: Command
    
    func present(state: State) {
        guard let note = state.allNotes.byId[noteID] else {
            fatalError("cannot display note for ID: \(noteID)")
        }
        
        render.perform(with: Props(
            title: note.text,
            text: note.text,
            edit: dispatch.bind(to: Actions.NotesView.Edit(noteId: noteID)),
            endObserving: Command {
                self.endObserving.perform()
            }
        ))
    }
}
