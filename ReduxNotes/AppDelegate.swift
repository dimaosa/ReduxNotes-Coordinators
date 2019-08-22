//
//  AppDelegate.swift
//  ReduxNotes
//
//  Created by Alexey Demedetskii on 6/17/18.
//  Copyright © 2018 Alexey Demedeckiy. All rights reserved.
//

import UIKit

import FirebaseDatabase
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    private lazy var coordinator: AppCoordinator = {
        let coordinator = AppCoordinator()
        coordinator.configure()
        return coordinator
    }()
    
    var window: UIWindow?
    
    private lazy var store: Store<State> = {
        let initialState = State(
            allNotes: AllNotes(byId: [:]),
            newNote: NewNote(text: ""),
            location: LocationState(latitude: Storage.lastKnownLocation.coordinate.latitude, longitude: Storage.lastKnownLocation.coordinate.longitude, authStatus: Storage.lastKnownAuthStatus)
        )
        
        return Store(
            state: initialState,
            middleware: [
                // Lod all actions disptacted to store
                createMiddleware(logMiddleware),
                // Manage Routing
                createCoordinatorMiddleware(coordinator.handle)
            ],
            reducer: reduce)
    }()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        defer {
            store.dispatch(action: Actions.Application.DidFinishLaunch())
        }
        
        StoreLocator.register(store: store)
        
        FirebaseApp.configure()
        startControllers()
        
        return true
    }
    
    private func startControllers() {
        ControllerFactory().startLocation()
        ControllerFactory().startFirebase()
    }
}
