//
//  Court.swift
//  BallCourts
//
//  Created by Chris Wong on 2016-03-05.
//  Copyright © 2016 Chris Wong. All rights reserved.
//

import Foundation
import UIKit
import Parse

class Court: CustomStringConvertible {
    var id: String
    var name: String
    var address: String
    var summary: String?
    var phone: String?
    var url: String?
    var hours: String?
    var latitude: Double
    var longitude: Double
    var image: UIImage?
    var rating: Double?
    var players: Int = 0
    
    var description: String {
        get {
            return "Id: \(id) Name: \(name) Address: \(address) Phone: \(phone!) Url: \(url!) Hours: \(hours!) Latitude: \(latitude) Longitude: \(longitude) Summary: \(summary!) Rating: \(rating!) Players: \(players)"
        }
    }

    
    init(id: String = "", name: String, address: String, summary: String?, phone: String?, url: String?, hours: String?, latitude: Double, longitude: Double, rating: Double?, players: Int ){
        self.id = id
        self.name = name
        self.address = address
        self.summary = summary
        self.phone = phone
        self.url = url
        self.hours = hours
        self.latitude = latitude
        self.longitude = longitude
        self.rating = rating
        self.players = players
    }
    
    convenience init (court: PFObject){
        
        let location = court["location"] as! PFGeoPoint
        
         self.init(id: court.objectId!, name: court["name"] as! String, address: court["address"] as! String, summary: court["description"] as? String, phone: court["phone"] as? String, url: court["url"] as? String, hours: court["hours"] as? String, latitude:  location.latitude, longitude:  location.longitude, rating: court["rating"] as? Double, players: court["players"] as! Int)
        
    }
}