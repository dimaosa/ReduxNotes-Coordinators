//
//  LocationCoordinator.swift
//  ReduxNotes
//
//  Created by Dima Osadchy on 15/08/2019.
//  Copyright © 2019 Alexey Demedeckiy. All rights reserved.
//

import CoreLocation

class LocationController: NSObject {
    struct Props {
        let authorizationStatus: CommandWith<CLAuthorizationStatus>
        let newLocation: CommandWith<CLLocation>
    }
    
    private var props = Props(authorizationStatus: .nop, newLocation: .nop)
    
    private let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        
        configureLocationManager()
    }
    
    private func configureLocationManager() {
        locationManager.delegate = self
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
    }
    
    private func dispatch(location: CLLocation?) {
        guard let location = location else { return }
        props.newLocation.perform(with: location)
    }
    
    func render(props: Props) {
        self.props = props
    }
}

extension LocationController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        props.authorizationStatus.perform(with: status)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        dispatch(location: locations.last)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
