//
//  AllNotesTableViewController.swift
//  ReduxNotes
//
//  Created by Dima Osadchy on 13/08/2019.
//  Copyright © 2019 Alexey Demedeckiy. All rights reserved.
//

import UIKit

final class AllNotesTableViewController: UITableViewController {
    struct Props {
        let title: String
        let notes: [Note]
        let addNewNote: Command
        let endObserving: Command
        
        struct Note {
            let title: String
            let select: Command
            let delete: Command
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCells()
        addTabBarItems()
    }
    
    deinit {
        props.endObserving.perform()
    }
    
    private var props = Props(title: "Notes", notes: [], addNewNote: .nop, endObserving: .nop)
    
    func render(props: Props) {
        self.props = props
        self.tableView.reloadData()
        
        view.setNeedsLayout()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        title = props.title
    }
    
    @IBAction func unwindToNotesList(segue: UIStoryboardSegue) {}
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return props.notes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NoteTableViewCell.reuseIdentifier) as! NoteTableViewCell
        cell.textLabel?.text = props.notes[indexPath.row].title
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        props.notes[indexPath.row].select.perform()
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            props.notes[indexPath.row].delete.perform()
        }
    }
    
    private func registerCells() {
        tableView.register(NoteTableViewCell.self, forCellReuseIdentifier: NoteTableViewCell.reuseIdentifier)
    }
    
    private func addTabBarItems() {
        navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewNote)), animated: false)
    }
    
    @objc private func addNewNote() {
        props.addNewNote.perform()
    }
}
