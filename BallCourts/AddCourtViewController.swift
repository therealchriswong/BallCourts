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

class AddCourtViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    var imagePicker: UIImagePickerController!
    var locationManager = CLLocationManager()

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
        // Create a new Contact
        //let contact = Contact()
        // Set its first and last names and email based on the text fields
//        if let firstName = firstNameField.text {
//            contact.firstName = firstName
//        }
//        if let lastName = lastNameField.text {
//            contact.lastName = lastName
//        }
//        if let email = emailField.text {
//            contact.email = email
//        }
        // Let the delegate know we want to save the new Contact
        //delegate?.saveNewContact(contact)
    }
    
    // Called when the Cancel button is tapped
    @IBAction func cancel() {
        // Let the delegate know we don't want to save a new Contact
        //delegate?.cancelAddContact()
    }
    
    // The delegate (for handling Save and Cancel)
    var delegate: AddCourtDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //checkLocationAuthorizationStatus()
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
    
    func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse {
            // Create map
            
            // Get current user location
            let latitude:CLLocationDegrees = 43.701736
            let longitude:CLLocationDegrees = -79.377145
            
            let latDelta:CLLocationDegrees = 0.05
            
            let longDelta:CLLocationDegrees = 0.05
            
            let span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, longDelta)
            
            let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
            
            let region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)
            
            map.setRegion(region, animated: true)
            
            // Handle Long Press Gesture by calliing action method
            // * the colon after "action" send gesture information. If no colon no information will be sent to the action method.
            let uilpgr = UILongPressGestureRecognizer(target: self, action: "action:")
            
            uilpgr.minimumPressDuration = 1
            
            map.addGestureRecognizer(uilpgr)

            
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func action(gestureRecongnizer: UIGestureRecognizer){
        print("Gesture recongnized")
        
        // clear annotations
        map.removeAnnotations(map.annotations)
        
        // the view is the map. the coordinate pressed is relative to the map not the coordinates in the map
        let touchPoint = gestureRecongnizer.locationInView(self.map)
        
        // convert user pressed coordinate to map
        let newCoordinate:CLLocationCoordinate2D = map.convertPoint(touchPoint, toCoordinateFromView: self.map)
        
        // Add annotation for home
        let annotation = MKPointAnnotation()
        
        annotation.coordinate = newCoordinate
        
        let address = reverseGeocoding(newCoordinate.latitude, longitude: newCoordinate.longitude)
        
        annotation.title = "New Court"
        
        annotation.subtitle = address
        
        map.addAnnotation(annotation)
        
        
    }
    
    func reverseGeocoding(latitude: CLLocationDegrees, longitude: CLLocationDegrees) -> String {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        var address: String = ""
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
            if error != nil {
                print(error)
            }
            else if placemarks?.count > 0 {
                let pm = placemarks![0]
                
                address = ABCreateStringWithAddressDictionary(pm.addressDictionary!, false)
            }
        })
        
        return address
    }
    
    func createMapSnapshot() -> NSData {
        let options = MKMapSnapshotOptions()
        options.region = self.map.region
        options.size = self.map.frame.size
        options.scale = UIScreen.mainScreen().scale
        
        var data: NSData?
        
        let snapshotter = MKMapSnapshotter(options: options)
        snapshotter.startWithCompletionHandler() { snapshot, error in
            
            let image = snapshot!.image
            data = UIImagePNGRepresentation(image)!
        }
        
        return data!
        
    }

}
