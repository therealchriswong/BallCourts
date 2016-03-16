//
//  CourtTableViewCell.swift
//  BallCourts
//
//  Created by Chris Wong on 2016-03-05.
//  Copyright © 2016 Chris Wong. All rights reserved.
//

import UIKit
import Parse

class CourtTableViewCell: UITableViewCell {

    @IBOutlet var courtImage: UIImageView!
    @IBOutlet var courtName: UILabel!
    @IBOutlet var distance: UILabel!
    @IBOutlet var information: UILabel!
    
    var currentLocation: PFGeoPoint?
    var court: Court? {
        didSet {
            if let court = self.court {
                
                self.courtName.text = court.name
                self.distance.text = "\( String(format: "%.2f", (currentLocation?.distanceInKilometersTo(PFGeoPoint(latitude: court.latitude, longitude: court.longitude)))!)) KM"
                self.information.text = "\(court.players) Players • \(court.rating!) Rating"
                

                let query = PFQuery(className: "Court")
                query.whereKey("objectId", equalTo: court.id)
                query.getFirstObjectInBackgroundWithBlock({ (object, error) -> Void in
                    if error == nil {
                        
                        let imageFile = object!["image"] as! PFFile

                        imageFile.getDataInBackgroundWithBlock { (imageData, error) -> Void in
                            if error == nil {
                                if let imageData = imageData {
                                    let image = UIImage(data: imageData)
                                    
                                    self.courtImage.image = image
                                }
                            }
                            else {
                                print("Error downloading Image: \(error)")
                            }
                        }
                    }
                    else {
                        print("Error: \(error)")
                    }
                })
            }
            else {
                self.courtImage = nil
                self.courtName = nil
                self.distance = nil
                self.information = nil
            }
        }
    }
}
