//
//  ViewController.swift
//  BallCourts
//
//  Created by Chris Wong on 2016-02-29.
//  Copyright © 2016 Chris Wong. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    
    var courts = [Court]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //DataService.dataService.getCourts()
        
        //self.tableView.reloadData()
        
        DataService.dataService.courtRef.observeEventType(.Value, withBlock: { snapshot -> Void in
            //code
            var courts = [Court]()
            
            for item in snapshot.children {
                let court = Court(snapshot: item as! FDataSnapshot)
                
                courts.append(court)
            }
            
            self.courts = courts
            self.tableView.reloadData()
        })
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let myTableCell = tableView.dequeueReusableCellWithIdentifier("court") as! CourtTableViewCell
        
        myTableCell.court = courts[indexPath.row]
        
        return myTableCell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // Sender is the courtTableViewCell
        if let cell = sender as? CourtTableViewCell {
            if let indexPath = tableView.indexPathForCell(cell) {
                let courtData = courts[indexPath.row]
                let courtDetailViewController = segue.destinationViewController as! CourtDetailViewController
                courtDetailViewController.court = courtData
            }
        }
    }

}

