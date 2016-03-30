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
    var id: String = ""
    var name: String = ""
    var address: String = ""
    var summary: String?
    var phone: String?
    var url: String?
    var hours: String?
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    var image: NSData?
    var rating: Double?
    var players: Int = 0
    var mapImage: NSData?
    
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
    
    
    internal func saveToDatabase() {
        let courtPFObject = PFObject(className: "Court")
        let mapImageFile = PFFile(name: "mapImage.jpg" , data: mapImage!)
        let imgFile = PFFile(name: "image.jpg", data: image!)
        
        //let imageFile = PFFile(name:"\(Int(arc4random_uniform(10)))\,\.jpg" data: court.image!)
        let point = PFGeoPoint(latitude: latitude, longitude: longitude)
        
        courtPFObject["name"] = name
        courtPFObject["address"] = address
        courtPFObject["location"] = point
        courtPFObject["description"] = summary
        courtPFObject["rating"] = 0.0
        courtPFObject["hours"] = hours
        courtPFObject["phone"] = phone
        courtPFObject["players"] = 0
        courtPFObject["image"] = imgFile
        courtPFObject["mapImage"] = mapImageFile
        courtPFObject["url"] = url
        
        courtPFObject.saveInBackgroundWithBlock { (success, error) -> Void in
            if error != nil {
                print("Error: \(error?.localizedDescription)")
            }
        }
    }
}