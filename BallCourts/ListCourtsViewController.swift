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


class ListCourtsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate, UISearchResultsUpdating, AddCourtDelegate{
    
    @IBOutlet var tableView: UITableView!
    
    var courts = [Court]()
    
    var locationManager = CLLocationManager()
    
    var searchController: UISearchController!
    
    var searchResults = [Court]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLocationManager()
        setupSearchBar()
    }
    
    // MARK: Setup Helper Methods
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func setupSearchBar() {
        searchController = UISearchController(searchResultsController: nil)
        tableView.tableHeaderView = searchController?.searchBar
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
    }
    
    // MARK: UITableViewDelegate Methods
    
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
        
        //TODO Put a border around the content view
        //myTableCell.contentView.layer.borderWidth = 0.5
        //myTableCell.contentView.layer.borderColor = UIColor.grayColor().CGColor
        
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
        
        if let addCourtViewController = segue.destinationViewController as? AddCourtViewController {
            // Tell the AddCourtViewController we will handle Cancel and Save
            addCourtViewController.delegate = self
        }
        
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
    
    // MARK: LocationManagerDelegate Methods
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            print("Found user location: \(location)")
            locationManager.stopUpdatingLocation()
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
    

    // MARK: Private Helpers
    
    func getCourtByLocation(location: CLLocation) {
        
        let query = PFQuery(className: "Court")
        
        query.whereKey("location", nearGeoPoint: PFGeoPoint(location: location), withinKilometers: 10 )
        
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if error == nil {
                print("Sucessfully retrieved \(objects!.count) courts")
                
                if let objects = objects {
                    self.courts = [Court]()
                    for court in objects {
                        // TODO: don't append
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
    
    // MARK: AddCourtDelegate
    
    func cancelAddCourt() {
        navigationController?.popViewControllerAnimated(true)

    }
    
    func saveNewCourt(court: Court) {
        navigationController?.popViewControllerAnimated(true)
        
        getCourtByLocation(locationManager.location!)
        if let courtIndex = courts.indexOf({$0 === court}) {
            //tableView.scrollToRowAtIndexPath(NSIndexPath(forItem: courtIndex, inSection: 0),
            //    atScrollPosition: UITableViewScrollPosition.Middle,
            //    animated: true)
            
            let indexPath = NSIndexPath(forRow: courtIndex, inSection: 0)
            tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)

            
        }
        
        // Animate the row appearing at the correct place
//        if let row = courts.indexOf(court) {
//            let indexPath = NSIndexPath(forRow: row, inSection: 0)
//            tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
//        }

    }
    
}

