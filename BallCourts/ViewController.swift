//
//  ViewController.swift
//  BallCourts
//
//  Created by Chris Wong on 2016-02-29.
//  Copyright © 2016 Chris Wong. All rights reserved.
//

import UIKit
import CoreLocation
import Parse


class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate  {
    
    @IBOutlet var tableView: UITableView!
    
    var courts = [Court]()
    
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        // Find the current user location
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager.requestLocation()
            print(locationManager.location)
            getCourtByLocation(locationManager.location!)
            
        }


    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let myTableCell = tableView.dequeueReusableCellWithIdentifier("court") as! CourtTableViewCell
        
        myTableCell.currentLocation = PFGeoPoint(location: locationManager.location)
        myTableCell.court = courts[indexPath.row]

        
        return myTableCell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // Sender is the courtTableViewCell
        if let cell = sender as? CourtTableViewCell {
            if let indexPath = tableView.indexPathForCell(cell) {
                let courtData = courts[indexPath.row]
                let courtDetailTableViewController = segue.destinationViewController as! CourtDetailsTableViewController
                courtDetailTableViewController.court = courtData
            }
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print("Found user location: \(location)")
            
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Failed to find user's location: \(error.localizedDescription)")
        
        let alert = UIAlertController(title: "Failed to find user's location", message: error.localizedFailureReason, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            self.dismissViewControllerAnimated(true, completion: nil)
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }

    func getCourtByLocation(location: CLLocation) {
        
        let query = PFQuery(className: "Court")
        
        query.whereKey("location", nearGeoPoint: PFGeoPoint(location: location), withinKilometers: 10 )
        
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if error == nil {
                print("Sucessfully retrieved \(objects!.count) courts")
                
                if let objects = objects {

                    for court in objects {
                        self.courts.append(Court(court: court))
                    }
                    self.tableView.reloadData()
                }
            }
            else {
                print("Error: \(error)")
            }
        }
    }
    
}

