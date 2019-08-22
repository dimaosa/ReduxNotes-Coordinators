struct NewNote {
    let text: String
}

extension Actions.Notes {
    struct UpdateNewNoteText: Action {
        let newText: String
    }
    
    struct ClearNewNote: Action {}
}

func reduce(state: NewNote, _ action: Action) -> NewNote {
    switch action {
        
    case let action as Actions.Notes.UpdateNewNoteText:
        return NewNote(text: action.newText)
        
    case is Actions.Notes.ClearNewNote,
         is Actions.Notes.AddNote:
        return NewNote(text: "")
        
    default:
        return state
    }
}
