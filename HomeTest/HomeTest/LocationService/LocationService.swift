//
//  LocationService.swift
//  HomeTest
//
//  Created by Duong Pham on 13/02/2022.
//

import Foundation
import CoreLocation
import RxSwift
import RxCocoa
protocol LocationServiceType {
    func requestPermission()
    var didChangeAuthorizationStatus: Observable<CLAuthorizationStatus> { get }
    var lastLocation: Observable<CLLocation> { get }
}

class LocationService: LocationServiceType {
    
    let locationManager = CLLocationManager()
    
    var didChangeAuthorizationStatus: Observable<CLAuthorizationStatus> {
        return locationManager.rx.didChangeAuthorizationStatus }
    
    var lastLocation: Observable<CLLocation> {
        return locationManager.rx.didUpdateLocations.compactMap { $0.first }
    }
    
    
    
    func requestPermission() {
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
    }
}
