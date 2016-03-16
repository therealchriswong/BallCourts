//
//  DataService.swift
//  BallCourts
//
//  Created by Chris Wong on 2016-03-05.
//  Copyright © 2016 Chris Wong. All rights reserved.
//

import Foundation
import Parse

class DataService {
    
    // Singleton
    static let dataService = DataService()
    
    func getCourtByLocation(location: CLLocation) -> [Court]{
        
        let query = PFQuery(className: "Court")
        
        var courts = [Court]()
        
        query.whereKey("location", nearGeoPoint: PFGeoPoint(location: location), withinKilometers: 1000 )
        
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if error == nil {
                print("Sucessfully retrieved \(objects!.count) courts")
                
                if let objects = objects {
                    for court in objects {
                        courts.append(Court(court: court))
                    }
                    
                }
            }
            else {
                print("Error: \(error)")
            }
        }
        
        return courts
        
    }
}