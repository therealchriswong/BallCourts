//
//  CourtInfoViewController.swift
//  BallCourts
//
//  Created by Chris Wong on 2016-03-18.
//  Copyright © 2016 Chris Wong. All rights reserved.
//

import UIKit
import Parse
import MapKit

class CourtInfoViewController: UIViewController {

    @IBOutlet var courtImage: UIImageView!
    @IBOutlet var courtTitle: UILabel!
    @IBOutlet var courtInformation: UILabel!
    @IBOutlet var summary: UITextView!
    @IBOutlet var summaryHeightConstraint: NSLayoutConstraint!
    @IBOutlet var address: UILabel!
    @IBOutlet var hours: UILabel!
    @IBOutlet var phone: UILabel!
    @IBOutlet var url: UILabel!
    @IBOutlet var map: UIImageView!
    
    @IBOutlet var hoursIcon: UIImageView!
    @IBOutlet var hoursStackView: UIStackView!
    var currentLocation: PFGeoPoint?
    var court: Court?
    
    override func viewDidLoad() {
        
        
        self.courtImage.tintColor = UIColor.blackColor()
        
        self.courtTitle.text = court?.name
        self.courtInformation.text = "\(court!.players) Players • \(court!.rating!) Rating • \( String(format: "%.2f", (currentLocation?.distanceInKilometersTo(PFGeoPoint(latitude: court!.latitude, longitude: court!.longitude)))!)) KM"
        
        self.summary.text = court?.summary

        //self.address.text = court?.address
        
        let tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "summaryLabelTapped:")
        summary.addGestureRecognizer(tapGestureRecognizer)
        
        //print("hours status= \(court?.hours)")
        
//        if court?.hours == "" {
//            //hoursStackView.hidden = true
//            hoursIcon.hidden = true
//            hours.hidden = true
//            
//        }
//        else {
//            self.hours.text = court?.hours
//        }
//        
//        //self.hours.text = court?.hours
//        self.phone.text = court?.phone
//        self.url.text = court?.url
        
        let query = PFQuery(className: "Court")
        query.whereKey("objectId", equalTo: court!.id)
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
                        print("Error downloading court image: \(error)")
                    }
                }
                
//                let mapImageFile = object!["mapImage"] as! PFFile
//                
//                mapImageFile.getDataInBackgroundWithBlock { (imageData, error) -> Void in
//                    if error == nil {
//                        if let imageData = imageData {
//                            let image = UIImage(data: imageData)
//                            
//                            self.map.image = image
//                        }
//                    }
//                    else {
//                        print("Error downloading map image: \(error)")
//                    }
//                }

                
            }
            else {
                print("Error: \(error)")
            }
        })
        
    }
    
    func summaryLabelTapped(recognizer: UITapGestureRecognizer) {
        
        //summaryHeightConstraint.constant = self.automaticOption = (automaticOptionOfCar ? "Automatic" : "Manual")
        
        summaryHeightConstraint.constant = summary.contentSize.height
        
        print("\(summary.contentSize.height)")
        
        UIView.animateWithDuration(0.3) { () -> Void in
            self.view.layoutIfNeeded()
        }
    }
    
    override func viewDidLayoutSubviews() {
        self.summary.setContentOffset(CGPointZero, animated: false)
    }

}
