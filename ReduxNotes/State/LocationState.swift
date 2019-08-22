//
//  LocationState.swift
//  ReduxNotes
//
//  Created by Dima Osadchy on 15/08/2019.
//  Copyright © 2019 Alexey Demedeckiy. All rights reserved.
//
import CoreLocation

class Storage {
    static let lastKnownLocation = CLLocation(latitude: 48.106166242, longitude: 16.568497726)
    static let lastKnownAuthStatus = CLAuthorizationStatus.notDetermined
}

struct LocationState {
    let latitude: Double
    let longitude: Double
    let authStatus: CLAuthorizationStatus
}

extension CLAuthorizationStatus: Codable {}

extension Actions {
    enum Location {
        struct NewLocation: Action {
            let latitude: Double
            let longitude: Double
        }
        
        struct NewAuthorizationStatus: Action, Codable {
            let authStatus: CLAuthorizationStatus
        }
    }
}

func reduce(state: LocationState, _ action: Action) -> LocationState {
    switch action {
    case let action as Actions.Location.NewLocation:
        return LocationState(latitude: action.latitude, longitude: action.longitude, authStatus: state.authStatus)
    case let action as Actions.Location.NewAuthorizationStatus:
        return LocationState(latitude: state.latitude, longitude: state.longitude, authStatus: action.authStatus)
    default:
        return state
    }
}
