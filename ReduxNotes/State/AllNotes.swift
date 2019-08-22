import Foundation

extension Actions {
    enum Notes {
        struct AddNote: Action {
            let id: String = UUID().uuidString
            let text: String
            let context: NewNotePresenter.Context
        }
        
        struct UpdateCommonNotes: Action {
            let noteInfo: [NoteInfo]
        }
    }
}


struct AllNotes {
    let byId: [Id: Note]
}

func reduce(state: AllNotes, _ action: Action) -> AllNotes {
    switch action {
    case let action as Actions.Notes.AddNote:
        var notes = state.byId
        notes[AllNotes.Id(value: action.id)] = Note(text: action.text, context: action.context)
        return AllNotes(byId: notes)
        
    case let action as Actions.Notes.UpdateCommonNotes:
        var notes = state.byId.filter({ $0.value.context == .personal })
        action.noteInfo.forEach {
            notes[AllNotes.Id(value: $0.id)] = Note(text: $0.text, context: $0.context)
        }
        return AllNotes(byId: notes)
        
    case let action as Actions.Notes.UpdateNote:
        var notes = state.byId
        notes[action.noteId] = Note(text: action.note.text, context: action.note.context)
        return AllNotes(byId: notes)
        
    case let action as Actions.Notes.Delete:
        var notes = state.byId
        notes.removeValue(forKey: action.noteId)
        return AllNotes(byId: notes)
        
    default:
        return state
    }
}

struct Note: Codable {
    let text: String
    let context: NewNotePresenter.Context
}

extension AllNotes {
    struct Id: Hashable, Equatable, Codable {
        let value: String
        
        var hashValue: Int { return value.hashValue }
        
        static func == (left: Id, right: Id) -> Bool {
            return left.value == right.value
        }
    }
}
