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
    @IBOutlet var summary: UILabel!
    @IBOutlet var address: UILabel!
    @IBOutlet var hours: UILabel!
    @IBOutlet var phone: UILabel!
    @IBOutlet var url: UILabel!
    @IBOutlet var map: MKMapView!
    
    var currentLocation: PFGeoPoint?
    var court: Court?
    
    override func viewDidLoad() {
        
        self.courtTitle.text = court?.name
        self.courtInformation.text = "\(court!.players) Players • \(court!.rating!) Rating • \( String(format: "%.2f", (currentLocation?.distanceInKilometersTo(PFGeoPoint(latitude: court!.latitude, longitude: court!.longitude)))!)) KM"
        
        self.summary.text = court?.summary
        self.address.text = court?.address
        self.hours.text = court?.hours
        self.phone.text = court?.phone
        self.url.text = court?.url
        
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
                        print("Error downloading Image: \(error)")
                    }
                }
            }
            else {
                print("Error: \(error)")
            }
        })
        
        
        let location = CLLocation(latitude: (court?.latitude)!, longitude: (court?.longitude)!)
        
        centerMapOnLocation(location)

    }
    
    func centerMapOnLocation(location: CLLocation){
        
        let latDelta:CLLocationDegrees = 0.01
        let longDelta:CLLocationDegrees = 0.01
        let span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, longDelta)
        let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        map.setRegion(region, animated: true)

        
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = self.court?.name
        annotation.subtitle = self.court?.address
        map.addAnnotation(annotation)
        

    }

}
