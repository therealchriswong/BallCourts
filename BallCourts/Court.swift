//
//  Court.swift
//  BallCourts
//
//  Created by Chris Wong on 2016-03-05.
//  Copyright © 2016 Chris Wong. All rights reserved.
//

import Foundation

class Court: CustomStringConvertible {
    var name: String?
    var address: String?
    var key: String
    var courtImages = [CourtImage]()
    var numberOfPlayers: Int?
    var distance: Int?
    var rating: Double?
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    
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
}