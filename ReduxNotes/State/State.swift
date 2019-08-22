import Foundation

struct State {
    let allNotes: AllNotes
    let newNote: NewNote
    let location: LocationState
}

func reduce(state: State, _ action: Action) -> State {
    return State(
        allNotes: reduce(state: state.allNotes, action),
        newNote: reduce(state: state.newNote, action),
        location: reduce(state: state.location, action)
    )
}
