//
//  Firebase+Middleware.swift
//  ReduxNotes
//
//  Created by Dima Osadchy on 14/08/2019.
//  Copyright © 2019 Alexey Demedeckiy. All rights reserved.
//

import Foundation
import Firebase

class FirebaseController {
    struct Props {
        let updateCommonNotes: CommandWith<[NoteInfo]>
        let commonNotes: [AllNotes.Id: Note]
    }
    
    private var props = Props(updateCommonNotes: .nop, commonNotes: [:])
    
    private let reference = Database.database().reference().child("notes/common")
    private var prevCommonNotes = [NoteInfo]()
    
    init() {
        connectFirebase()
    }
    
    func render(props: Props) {
        self.props = props
        
        saveCommonNotesToFirebase()
    }
    
    private func connectFirebase() {
        startListeningFirebaseNotes()
    }
    
    private func saveCommonNotesToFirebase() {
        let notes: [[String: String]] = props.commonNotes.map { value in
            return [
                "id": value.key.value,
                "text": value.value.text
            ]
        }
        
        
        if prevCommonNotes.sorted(by: { $0.id > $1.id }) != props.commonNotes.map({ NoteInfo(id: $0.key.value, text: $0.value.text, context: $0.value.context) }).sorted(by: { $0.id > $1.id }) {
            reference.setValue(notes)
        }
        
        prevCommonNotes = props.commonNotes.map({ NoteInfo(id: $0.key.value, text: $0.value.text, context: $0.value.context)})
    }
    
    private func startListeningFirebaseNotes() {
        reference.observeSingleEvent(of: .value) { [weak self] snapshot in
            self?.handleFirebaseNotes(snapshot: snapshot)
        }
        reference.observe(.value, with: handleFirebaseNotes)
    }
    
    private func handleFirebaseNotes(snapshot data: DataSnapshot) {
        guard let notesArray = data.value as? [Any] else {
            return
        }
        
        var notes: [NoteInfo] = []
        for anyNote in notesArray {
            guard let note = anyNote as? [String: String] else { return }
            guard let id = note["id"] else { return }
            guard let text = note["text"] else { return }
            
            notes.append(NoteInfo(id: id, text: text, context: .common))
        }
        
        if prevCommonNotes.sorted(by: { $0.id > $1.id }) != notes.sorted(by: { $0.id > $1.id }) {
            props.updateCommonNotes.perform(with: notes)
        }
    }
}

struct NoteInfo: Codable, Equatable {
    let id: String
    let text: String
    let context: NewNotePresenter.Context
}
