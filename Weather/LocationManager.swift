//
//  LocationManager.swift
//  Weather
//
//  Created by Sai Pavan Neerukonda on 6/4/23.
//  Copyright © 2023 Sai Pavan Neerukonda. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

extension NSNotification.Name {
    static let sharedLocation = NSNotification.Name("sharedLocation")
}

class LocationManager: NSObject, CLLocationManagerDelegate {

    static let shared = LocationManager()
    let locationManager: CLLocationManager = CLLocationManager()
    private var requestLocationAuthorizationCallback: ((CLAuthorizationStatus) -> Void)?
    private let notificationCenter = NotificationCenter.default


    public func requestLocationAuthorization() {
        self.locationManager.delegate = self
        let currentStatus = locationManager.authorizationStatus
        
        // Only ask authorization if it was never asked before
        guard currentStatus == .notDetermined else {
            locationManager.requestLocation()
            return
        }
        self.requestLocationAuthorizationCallback = { status in
            if status == .authorizedWhenInUse {
            }
        }
        self.locationManager.requestWhenInUseAuthorization()
    }
    
    // MARK: - CLLocationManagerDelegate
    public func locationManager(_ manager: CLLocationManager,
                                didChangeAuthorization status: CLAuthorizationStatus) {
        self.requestLocationAuthorizationCallback?(status)
        if status == .authorizedWhenInUse || status ==  .authorizedAlways {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locationObj = locations.first
        DispatchQueue.main.async {
            self.setupNotificationCenter(object: locationObj)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func setupNotificationCenter(object: Any? = nil) {
           notificationCenter.post(name: .sharedLocation, object: object)
       }
    
}
