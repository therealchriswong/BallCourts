//
//  LocationService.swift
//  BallCourts
//
//  Created by Chris Wong on 2016-04-16.
//  Copyright © 2016 Chris Wong. All rights reserved.
//

import Foundation
import CoreLocation

protocol LocationUpdateProtocol {
    func locationDidUpdateToLocation(location : CLLocation)
}

class LocationService: NSObject, CLLocationManagerDelegate {
    
    static let sharedInstance = LocationService()
    
    private var locationManager = CLLocationManager()
    
    var currentLocation : CLLocation?
    
    var delegate : LocationUpdateProtocol!
    
    private override init () {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.startUpdatingLocation()
    }

    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //code
    }
    
    // Mark: - CLLocationManagerDelegate
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        currentLocation = newLocation
        //let userInfo : NSDictionary = ["location" : currentLocation!]
        
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.delegate.locationDidUpdateToLocation(self.currentLocation!)
            //NSNotificationCenter.defaultCenter().postNotificationName(kLocationDidChangeNotification, object: self, userInfo: userInfo as [NSObject : AnyObject])
        }
    }

}