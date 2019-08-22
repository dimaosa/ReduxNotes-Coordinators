
struct NewNotePresenter {
    typealias Props = NewNoteViewController.Props
    
    let render: CommandWith<Props>
    let dispatch: CommandWith<Action>
    let endObserving: Command
    
    let context: Context
    
    enum Context: String, Codable {
        case personal, common
    }
    
    func present(state: State) {
        
        func saveAction() -> Action? {
            guard state.newNote.text.count > 0 else { return nil }
            return Actions.Notes.AddNote(text: state.newNote.text, context: context)
        }
        
        let props = Props(
            title: "New Note",
            text: state.newNote.text,
            updateText: dispatch.map(transform: Actions.Notes.UpdateNewNoteText.init),
            cancel: dispatch.bind(to: Actions.Notes.ClearNewNote()),
            save: Command {
                if let action = saveAction() {
                    self.dispatch.perform(with: action)
                    self.dispatch.perform(with: Actions.Notes.ClearNewNote())
                }
            },
            endObserving: Command { self.endObserving.perform() }
        )
        
        render.perform(with: props)
    }
}
