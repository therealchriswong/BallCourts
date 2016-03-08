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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var myTableCell = tableView.dequeueReusableCellWithIdentifier("cell") as? CourtTableViewCell
        
        if myTableCell == nil {
            myTableCell = CourtTableViewCell(style: .Subtitle, reuseIdentifier: "cell")
        }

        myTableCell?.courtName?.text = courts[indexPath.row].name
        myTableCell?.distance.text = "999 KM"
        myTableCell?.information.text = "BLAH・BLAH・BLAH"
        
        return myTableCell!
    }

}

