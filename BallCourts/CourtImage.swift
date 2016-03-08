//
//  CourtImage.swift
//  BallCourts
//
//  Created by Chris Wong on 2016-03-05.
//  Copyright © 2016 Chris Wong. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class CourtImage {
 
    var description: String
    var image: UIImage
    
    init(description: String, image: UIImage){
        self.description = description
        self.image = image
    }
    
    init(snapshot: FDataSnapshot){
        self.description = snapshot.value["description"] as! String
        self.image = Util.util.decodeToUIImage(snapshot.value["base64String"] as! String)
    }
    
    
}