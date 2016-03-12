//
//  CourtTableViewCell.swift
//  BallCourts
//
//  Created by Chris Wong on 2016-03-05.
//  Copyright © 2016 Chris Wong. All rights reserved.
//

import UIKit

class CourtTableViewCell: UITableViewCell {

    @IBOutlet var courtImage: UIImageView!
    @IBOutlet var courtName: UILabel!
    @IBOutlet var distance: UILabel!
    @IBOutlet var information: UILabel!
    
    var court: Court? {
        didSet{
            if let court = self.court {
                
                self.courtName.text = court.name
                self.distance.text = "\(court.distance) KM"
                self.information.text = "99\(court.numberOfPlayers) Players • ✭✭✭\(court.rating)"
                
                //if let image = court.courtImages[0].image {
                    courtImage.image = court.courtImages[0].image
                //}
                //else {
                    //courtImage.image = nil
                //}
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
