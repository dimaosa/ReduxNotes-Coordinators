//
//  MenuCoordinator.swift
//  ReduxNotes
//
//  Created by Dima Osadchy on 12/08/2019.
//  Copyright © 2019 Alexey Demedeckiy. All rights reserved.
//
import UIKit

final class MenuCoordinator: Coordinator {

    var current: Coordinator?
    var rootViewController = MenuScreenFactory().mainMenu()
    
    private let personalNotes = MenuScreenFactory().personalNotes()
    private let commonNotes = MenuScreenFactory().commonNotes()

    init() {
        configureMainMenu()
    }
    
    func handle(_ state: State, action: Action) {
        switch action {
        case let action as Actions.NotesView.SelectedAction:
            push(controller: MenuScreenFactory().connectDetails(noteID: action.noteId))
        case let action as Actions.NotesView.AddNewNoteAction:
            present(controller: UINavigationController(rootViewController: MenuScreenFactory().newNote(context: action.context)))
        case let action as Actions.NotesView.Edit:
            present(controller: UINavigationController(rootViewController: MenuScreenFactory().editNote(noteId: action.noteId)), command: Command { self.popCurrentViewController() })
        case is Actions.Notes.ClearNewNote:
            dismissCurrentViewController()
        default:
           current?.handle(state, action: action)
        }
    }
    
    // MARK: - Private
    //
    private func configureMainMenu() {
        guard let mainTabBar = rootViewController as? MenuTabBarViewController else { return }
        mainTabBar.configureTabBar(personalNotes: UINavigationController(rootViewController: self.personalNotes), commonNotes: UINavigationController(rootViewController: self.commonNotes))
    }
    
    private func push(controller: UIViewController) {
        guard let navigation = (rootViewController as? MenuTabBarViewController)?.selectedViewController as? UINavigationController else { return }
        navigation.pushViewController(controller, animated: true)
    }
    
    private func present(controller: UIViewController, command: Command? = nil) {
        rootViewController.present(controller, animated: false, completion: { command?.perform() })
    }
    
    private func popCurrentViewController() {
        guard let navigation = (rootViewController as? MenuTabBarViewController)?.selectedViewController as? UINavigationController else { return }
        navigation.popViewController(animated: false)
    }
    
    private func dismissCurrentViewController() {
        rootViewController.dismiss(animated: true)
    }
}
