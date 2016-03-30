//
//  AddCourtViewController.swift
//  BallCourts
//
//  Created by Chris Wong on 2016-03-18.
//  Copyright © 2016 Chris Wong. All rights reserved.
//

import UIKit
import MapKit
import AddressBookUI

protocol AddCourtDelegate {
    
    func cancelAddCourt()
    
    func saveNewCourt(court: Court)
    
}

class AddCourtViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    var imagePicker: UIImagePickerController!
    var locationManager = CLLocationManager()

    // The delegate (for handling Save and Cancel)
    var delegate: AddCourtDelegate?
    
    @IBOutlet var name: UITextField!
    @IBOutlet var summary: UITextField!
    @IBOutlet var hours: UITextField!
    @IBOutlet var phone: UITextField!
    @IBOutlet var url: UITextField!
    @IBOutlet var map: MKMapView!
    
    @IBOutlet var courtImage: UIImageView!
    
    
    @IBAction func takePhoto(sender: AnyObject) {
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self

        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        imagePicker.allowsEditing = false
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    
    // Called when the Save button is tapped
    @IBAction func save() {
        // Create a new Court
        
        if let annotation = map.annotations.first {
            
            let options = MKMapSnapshotOptions()
            options.region = self.map.region
            options.size = self.map.frame.size
            options.scale = UIScreen.mainScreen().scale
            
            let snapshotter = MKMapSnapshotter(options: options)
            snapshotter.startWithCompletionHandler() { snapshot, error in
                
                if error != nil {
                    print("Error: \(error?.localizedDescription)")
                }
                else {
                    //let data = UIImagePNGRepresentation(snapshot!.image)
                    
                    let court = Court(name: self.name.text!, address: annotation.subtitle!!, summary: self.summary.text, phone: self.phone.text, url: self.url.text, hours: self.url.text, latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude, rating: 0.0, players: 0)
                    
                    court.image = UIImageJPEGRepresentation(self.courtImage.image!, 0.5)
                    court.mapImage = UIImageJPEGRepresentation(snapshot!.image, 0.5)
                    
                    // Let the delegate know we want to save the new Contact
                    court.saveToDatabase()
                    self.delegate?.saveNewCourt(court)
                    
                }
            }
        }
    }
    
    // Called when the Cancel button is tapped
    @IBAction func cancel() {
        // Let the delegate know we don't want to save a new Contact
        delegate?.cancelAddCourt()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.startUpdatingLocation()
        //self.map.showsUserLocation = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        // dismiss the choosing image view
        self.dismissViewControllerAnimated(true, completion: nil)
        // set image
        courtImage.image = image
    }
    
    func action(gestureRecongnizer: UIGestureRecognizer){
        
        //Clear Annotations
        map.removeAnnotations(map.annotations)
        
        // the view is the map. the coordinate pressed is relative to the map not the coordinates in the map
        let touchPoint = gestureRecongnizer.locationInView(self.map)
        
        // convert user pressed coordinate to map
        let newCoordinate:CLLocationCoordinate2D = map.convertPoint(touchPoint, toCoordinateFromView: self.map)
        
        requestReverseGeocoding(newCoordinate.latitude, longitude: newCoordinate.longitude)
        
    }
    
    func requestReverseGeocoding(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let location = CLLocation(latitude: latitude, longitude: longitude)

        CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
            if error != nil {
                print(error)
            }
            else if placemarks?.count > 0 {
                let placeMark = placemarks![0]
                
                let name = placeMark.addressDictionary?["Name"]
                
                // Add annotation
                let annotation = MKPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                annotation.title = name as? String
                annotation.subtitle = self.displayLocationInfo(placeMark)
                
                self.map.addAnnotation(annotation)
                
                // center map on annotation
                self.map.setCenterCoordinate(annotation.coordinate, animated: true)
            }
        })
    }
    
//    func createMapSnapshot() {
//        let options = MKMapSnapshotOptions()
//        options.region = self.map.region
//        options.size = self.map.frame.size
//        options.scale = UIScreen.mainScreen().scale
//        
//        let snapshotter = MKMapSnapshotter(options: options)
//        snapshotter.startWithCompletionHandler() { snapshot, error in
//            
//            if error != nil {
//                print("Error: \(error?.localizedDescription)")
//            }
//            else {
//                let data = UIImagePNGRepresentation(snapshot!.image)
//            }
//        }
//    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locations = locations.last
        let center = CLLocationCoordinate2D(latitude: locations!.coordinate.latitude, longitude: locations!.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
        
        self.map.setRegion(region, animated: true)
        
        self.locationManager.stopUpdatingLocation()
        
        // Add Gesture
        // Handle Long Press Gesture by calling action method
        // * the colon after "action" send gesture information. If no colon no information will be sent to the action method.
        let longPress = UILongPressGestureRecognizer(target: self, action: "action:")
        longPress.minimumPressDuration = 1.0
        map.addGestureRecognizer(longPress)
        
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Errors: \(error.localizedDescription)")
    }
    
    func displayLocationInfo(placeMark: CLPlacemark) -> String {
        
        var address: String = ""
        
        // Street
        if let street = placeMark.addressDictionary?["Street"] as? NSString
        {
            address += street as String + ", "
        }
        // City
        if let city = placeMark.addressDictionary?["City"] as? NSString
        {
            address += city as String + ", "
        }
        // State (Province)
        if let state = placeMark.addressDictionary?["State"] as? NSString
        {
            address += state as String + ", "
        }
        // ZIP (Postal Code)
        if let zip = placeMark.addressDictionary?["ZIP"] as? NSString
        {
            address += zip as String + ", "
        }
        // Country
        if let country = placeMark.addressDictionary?["Country"] as? NSString
        {
            address += country as String
        }
        
        return address
    }

}
