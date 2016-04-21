//
//  CourtInfoViewController.swift
//  BallCourts
//
//  Created by Chris Wong on 2016-03-18.
//  Copyright © 2016 Chris Wong. All rights reserved.
//

import UIKit
import Parse

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
    
    @IBOutlet var hoursStackView: UIStackView!
    @IBOutlet var locationStackView: UIStackView!
    @IBOutlet var phoneStackView: UIStackView!
    @IBOutlet var urlStackView: UIStackView!
    
    var currentLocation: PFGeoPoint?
    var court: Court?
    
    override func viewDidLoad() {
        
        setupCourtName()
        
        setupCourtInformation()
        
        setupCourtDescription()
        
        setupLocation()
        
        setupHours()
        
        setupPhone()
        
        setupURL()
        
        setupCourtImage()
 
        setupMapImage()
        
    }
    
    // MARK: Setup Helper Methods
    
    func setupCourtName() {
        
        if let courtName = court?.name {
            self.courtTitle.text = courtName
        }
    }

    func setupCourtInformation() {
        
        if let numberOfPlayers = court?.players, courtRating = court?.rating, courtLatitude = court?.latitude, courtLongitude = court?.longitude {
            
            self.courtInformation.text = "\(numberOfPlayers) Players • \(courtRating) Rating • \( String(format: "%.2f", (currentLocation?.distanceInKilometersTo(PFGeoPoint(latitude: courtLatitude, longitude: courtLongitude)))!)) KM"
            
        }
    }
    
    func setupCourtDescription() {
        if let description = court?.summary {
            self.summary.text = description
            
            let tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "summaryLabelTapped:")
            self.summary.addGestureRecognizer(tapGestureRecognizer)
        }
    }
    
    func setupLocation() {
        if court?.address == "" {
            locationStackView.hidden = true
        }
        else {
            if let address = court?.address {
                self.address.text = address
            }
        }
    }
    
    func setupHours() {
        if court?.hours == "" {
            hoursStackView.hidden = true
        }
        else {
            if let hours = court?.hours {
                self.hours.text = hours
            }
        }
    }
    
    func setupPhone() {
        if court?.phone == "" {
            phoneStackView.hidden = true
        }
        else {
            if let phone = court?.phone {
                self.phone.text = phone
            }
        }
    }
    
    func setupURL() {
        if court?.url == "" {
            urlStackView.hidden = true
        }
        else {
            if let url = court?.url {
                self.url.text = url
            }
        }

    }
    
    func setupCourtImage() {
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
            }
            else {
                print("Error: \(error)")
            }
        })

    }
    
    func setupMapImage() {
        let query = PFQuery(className: "Court")
        query.whereKey("objectId", equalTo: court!.id)
        query.getFirstObjectInBackgroundWithBlock({ (object, error) -> Void in
            if error == nil {
                let mapImageFile = object!["mapImage"] as! PFFile
                mapImageFile.getDataInBackgroundWithBlock { (imageData, error) -> Void in
                    if error == nil {
                        if let imageData = imageData {
                            let image = UIImage(data: imageData)
                            self.map.image = image
                        }
                    }
                    else {
                        print("Error downloading map image: \(error)")
                    }
                }
            }
            else {
                print("Error: \(error)")
            }
        })

    }
    
    func summaryLabelTapped(recognizer: UITapGestureRecognizer) {
      
        summaryHeightConstraint.constant = summary.contentSize.height
        
        UIView.animateWithDuration(0.3) { () -> Void in
            self.view.layoutIfNeeded()
        }
    }
    
    override func viewDidLayoutSubviews() {
        self.summary.setContentOffset(CGPointZero, animated: false)
    }

}
