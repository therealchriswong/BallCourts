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


class ListCourtsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate, UISearchResultsUpdating, AddCourtDelegate, LocationUpdateProtocol {
    
    @IBOutlet var tableView: UITableView!
    
    var courts = [Court]()
    
    var searchController: UISearchController!
    
    var searchResults = [Court]()
    
    var currentLocation : CLLocation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUserLocationManager()
        setupSearchBar()
    
    }
    
    // MARK: Setup Helper Methods
    
    func setupUserLocationManager() {
        
        let userLocationManager = UserLocationManager.SharedManager
        
        userLocationManager.delegate = self

        userLocationManager.startUpdatingLocation()

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
        
        let courtTableViewCell = tableView.dequeueReusableCellWithIdentifier("court") as! CourtTableViewCell
        
        courtTableViewCell.currentLocation = PFGeoPoint(location: currentLocation)
        
        if searchController.active {
            courtTableViewCell.court = searchResults[indexPath.row]
        }
        else {
            courtTableViewCell.court = courts[indexPath.row]

        }
                
        return courtTableViewCell
    }
    
    
    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        let cell =  self.tableView.cellForRowAtIndexPath(indexPath)

        UIView.animateWithDuration(0.1, delay: 0, options: [.BeginFromCurrentState, .CurveEaseOut], animations: { () -> Void in
            cell?.transform = CGAffineTransformMakeScale(0.95, 0.95)

            }) { (completed) -> Void in
                
        }
        
        return true
    }
    
    func tableView(tableView: UITableView, didUnhighlightRowAtIndexPath indexPath: NSIndexPath) {
        let cell =  self.tableView.cellForRowAtIndexPath(indexPath)
        
        UIView.animateWithDuration(0.1, delay: 0, options: [.BeginFromCurrentState, .CurveEaseOut], animations: { () -> Void in
            cell?.transform = CGAffineTransformIdentity
            }) { (completed) -> Void in
                
        }
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
                
                courtInfoViewController.currentLocation = PFGeoPoint(location: currentLocation)

                if searchController.active {
                    courtInfoViewController.court = searchResults[indexPath.row]
                }
                else {
                    courtInfoViewController.court = courts[indexPath.row]


                }
            }
        }
    }
    
    // MARK: UserLocationManager Protocol
    
    func locationDidUpdateToLocation(location : CLLocation){
        currentLocation = location
        
        print("Current Location")
        print("Latitude : \(self.currentLocation.coordinate.latitude)")
        print("Longitude : \(self.currentLocation.coordinate.longitude)")
        
        getCourtByLocation(currentLocation)
        
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
        
        getCourtByLocation(currentLocation)
        if let courtIndex = courts.indexOf({$0 === court}) {
            let indexPath = NSIndexPath(forRow: courtIndex, inSection: 0)
            tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }

    }
    
}

