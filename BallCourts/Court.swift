//
//  Court.swift
//  BallCourts
//
//  Created by Chris Wong on 2016-03-05.
//  Copyright © 2016 Chris Wong. All rights reserved.
//

import Foundation
import Firebase

class Court: CustomStringConvertible {
    var name: String?
    var address: String?
    var key: String
    var courtImages = [CourtImage]()
    var numberOfPlayers: Int?
    
    var description: String {
        get {
            return "Name: \(name) Key: \(key) Address: \(address)"
        }
    }

    
    init(key: String = "", name: String, address: String, numberOfPlayers: Int, image: [CourtImage] ){
        self.name = name
        self.key = key
        self.address = address
        self.numberOfPlayers = numberOfPlayers
        //self.image.append(image)
    }
    
    init(snapshot: FDataSnapshot){
        self.key = snapshot.key
        self.name = snapshot.value["name"] as? String
        self.address = snapshot.value["address"] as? String
      
        /*TRYING TO GET KEY IMAGES */
      
        for imageSnapshot in snapshot.childSnapshotForPath("images").children {

            //let imageObject = imageSnapshot as! FDataSnapshot
            //print(imageObject.value["name"] as? String)
            //print(imageObject.value["description"] as? String)
            //print(imageObject.value["base64String"] as? String)

            self.courtImages.append(CourtImage(snapshot: imageSnapshot as! FDataSnapshot))
        }
        
    }
    
}