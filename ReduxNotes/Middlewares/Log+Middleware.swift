//
//  Log+Middleware.swift
//  ReduxNotes
//
//  Created by Dima Osadchy on 14/08/2019.
//  Copyright © 2019 Alexey Demedeckiy. All rights reserved.
//

func logMiddleware(state: State, action: Action) -> Action? {
    print("Redux action \(action)")
    return action
}
