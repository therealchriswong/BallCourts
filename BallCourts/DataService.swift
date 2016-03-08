//
//  DataService.swift
//  BallCourts
//
//  Created by Chris Wong on 2016-03-05.
//  Copyright © 2016 Chris Wong. All rights reserved.
//

import Foundation
import Firebase

class DataService {
    
    // Singleton
    static let dataService = DataService()
    
    var rootRef = Firebase(url: ROOT_URL)
    var courtRef = Firebase(url: "\(ROOT_URL)/courts")
    
    
//    func getCourts() -> [Court] {
//        
//        let courts = [Court]()
//
//        return courts
//        
//    }
    
    
    
    // Create a reference to a Firebase location
    //let myRootRef = Firebase(url:"https://ballcourts.firebaseio.com/courts/-KBzrNZGlXu8zXSuqj3d/images")
    // Write data to Firebase
    
    // make a new UIImage
    //let uploadImage = UIImage(named: "scadding1.jpg")
    // make an NSData Jpeg rep of the image
    //let imageData = UIImageJPEGRepresentation(uploadImage!, 1.0)!
    
    //let base64String = imageData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
    //let image1 = ["name":"scadding1","description":"a description","base64String":base64String]
    
    //let imageRef = myRootRef.childByAutoId()
    //imageRef.setValue(image1)
    
    
    /*
    let courtsRef = myRootRef.childByAppendingPath("courts")
    
    let court1Ref = courtsRef.childByAutoId()
    let court = ["name":"Scadding Park", "address": "235 The Esplanade, Toronto, ON M5A 4J6", "coordinates":["latitude":43.649515, "longitude": -79.364123]]
    court1Ref.setValue(court)
    
    let court2Ref = courtsRef.childByAutoId()
    let court2 = ["name":"Harbourfront Community Centre", "address": "627 Queens Quay W, Toronto, ON M5V 3G3", "coordinates":["latitude":43.655064, "longitude": -79.355882]]
    court2Ref.setValue(court2)
    
    
    let court3Ref = courtsRef.childByAutoId()
    let court3 = ["name":"Hoopdome", "address": "75 Carl Hall Rd #17, North York, ON M3K 2B9", "email": "tbadner@hoopdome.com","phone": "(416) 633-4667", "coordinates":["latitude":43.655064, "longitude": -79.355882], "hours":"9:30AM-10:30PM"]
    court3Ref.setValue(court3)
    
    let court4Ref = courtsRef.childByAutoId()
    let court4 = ["name":"Underpass Park", "address": "31 Lower River St, Toronto, ON M5A 1M6", "coordinates":["latitude":43.655064, "longitude": -79.355882]]
    court4Ref.setValue(court4)
    */
    
}