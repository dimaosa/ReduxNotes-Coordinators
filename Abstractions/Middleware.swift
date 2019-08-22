//
//  CoordinatorMiddleware.swift
//  ReduxNotes
//
//  Created by Dima Osadchy on 12/08/2019.
//  Copyright © 2019 Alexey Demedeckiy. All rights reserved.
//

import Foundation

/// Creates a middleware function to create a Middleware function.
func createMiddleware(_ handler: @escaping (State, Action) -> (Action?)) -> Middleware<State> {
    return { dispatch, state, next in
        return { action in
            if let newAction = handler(state(), action) {
                next(newAction)
            }
        }
    }
}

/// Creates a middleware for a coordinator, all actions are dispatch to main queue async
func createCoordinatorMiddleware(_ handler: @escaping (State, Action) -> ()) -> Middleware<State> {
    return { dispatch, state, next in
        return { action in
            next(action)
            DispatchQueue.main.async {
                handler(state(), action)
            }
        }
    }
}
