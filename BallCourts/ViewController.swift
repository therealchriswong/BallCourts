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


class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate, UISearchResultsUpdating  {
    
    @IBOutlet var tableView: UITableView!
    
    var courts = [Court]()
    
    var locationManager = CLLocationManager()
    
    var searchController: UISearchController!
    
    var searchResults = [Court]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        // Set the delegate
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        
        searchController = UISearchController(searchResultsController: nil)
        tableView.tableHeaderView = searchController?.searchBar
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchController.active {
            return searchResults.count
        }
        else {
            return courts.count

        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let myTableCell = tableView.dequeueReusableCellWithIdentifier("court") as! CourtTableViewCell
        
        myTableCell.currentLocation = PFGeoPoint(location: locationManager.location)
        
        if searchController.active {
            myTableCell.court = searchResults[indexPath.row]
        }
        else {
            myTableCell.court = courts[indexPath.row]

        }
        
        return myTableCell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // Sender is the courtTableViewCell
        if let cell = sender as? CourtTableViewCell {
            if let indexPath = tableView.indexPathForCell(cell) {
                let courtInfoViewController = segue.destinationViewController as! CourtInfoViewController
                
                courtInfoViewController.currentLocation = PFGeoPoint(location: locationManager.location)

                if searchController.active {
                    courtInfoViewController.court = searchResults[indexPath.row]
                }
                else {
                    courtInfoViewController.court = courts[indexPath.row]


                }
                
            }
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print("Found user location: \(location)")
            
            getCourtByLocation(location)
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
    
    func filterContentForSearchText(searchText: String) {
        searchResults = courts.filter({ (Court) -> Bool in
            let nameMatch = Court.name.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch  )
            
            return nameMatch != nil
        })
        
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            filterContentForSearchText(searchText)
            tableView.reloadData()
        }
    }
}

