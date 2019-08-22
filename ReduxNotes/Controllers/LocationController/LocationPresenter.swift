//
//  LocationPresenter.swift
//  ReduxNotes
//
//  Created by Dima Osadchy on 15/08/2019.
//  Copyright © 2019 Alexey Demedeckiy. All rights reserved.
//

import Foundation

struct LocationPresenter {
    typealias Props = LocationController.Props
    
    let render: CommandWith<Props>
    let dispatch: CommandWith<Action>
    
    func present(state: State) {
        render.perform(with: Props(
            authorizationStatus: dispatch.map(transform: Actions.Location.NewAuthorizationStatus.init),
            newLocation: CommandWith { location in
                self.dispatch.bind(to: Actions.Location.NewLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude))
            }))
    }
}
