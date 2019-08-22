import UIKit

extension Actions {
    enum NotesView {
        struct SelectedAction: Action {
            let noteId: AllNotes.Id
        }
        
        struct AddNewNoteAction: Action {
            let context: NewNotePresenter.Context
        }
    }
}

extension Actions.Notes {
    struct Delete: Action {
        let noteId: AllNotes.Id
    }
}

struct PersonalNotesTablePresenter {
    typealias Props = AllNotesTableViewController.Props
    
    let render: CommandWith<Props>
    let dispatch: CommandWith<Action>
    let endObserving: Command
    
    func present(state: State) {
        let notes = state.allNotes.byId.filter({ $0.value.context == .personal }).map { note -> Props.Note in
            return Props.Note(
                title: note.value.text,
                select: dispatch.bind(to: Actions.NotesView.SelectedAction(noteId: note.key)),
                delete: dispatch.bind(to: Actions.Notes.Delete(noteId: note.key))
            )
        }
        
        let props = Props(
            title: "Personal Notes",
            notes: notes,
            addNewNote: dispatch.bind(to: Actions.NotesView.AddNewNoteAction(context: .personal)),
            endObserving: Command {
                self.endObserving.perform()
            }
        )
        
        render.perform(with: props)
    }
}
