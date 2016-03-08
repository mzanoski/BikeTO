//
//  RecentViewController.swift
//  BikeTO
//
//  Created by Marko Zanoski on 2016-02-09.
//  Copyright © 2016 Marko Zanoski. All rights reserved.
//

import UIKit
import MapKit

class RecentViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIViewControllerWithData 	{
    @IBOutlet weak var noRecentsLabel: UILabel!
    @IBOutlet weak var recentsTableView: UITableView!
    
    //    var data = MockDataSource().data
    internal var data = [StationDataType]()
    let cellIdentifier = "default"
    
    @IBAction func clearRecentItems(sender: AnyObject) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        for  item in self.data {
            appDelegate.dataController.removeLocation(item.id, entityType: EntityType.Recent)
        }
        self.data.removeAll()
        recentsTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //configure colors
        self.recentsTableView.separatorColor = UIColor.clearColor()
    }
    
    override func viewWillAppear(animated: Bool) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        self.data = ApplicationData.Data.items.filter({appDelegate.dataController.hasLocation($0.id, entityType: EntityType.Recent)})
        
        if data.count > 0 {
            recentsTableView.dataSource = self
            recentsTableView.hidden = false
            noRecentsLabel.hidden = true
        }
        else{
            recentsTableView.hidden = true
            noRecentsLabel.hidden = false
        }
        recentsTableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func searchForBikeStations(sender: AnyObject) {
        self.tabBarController?.selectedViewController = self.tabBarController?.viewControllers![1]
    }
    
    // MARK:  UITextFieldDelegate Methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as UITableViewCell
        
        let row = indexPath.row
        let item = data[row] as StationDataType
        
        cell.contentView.backgroundColor = ApplicationSettings.Settings.theme["baseColorLight"] as! UIColor
        cell.textLabel!.text = item.stationName
        cell.textLabel!.textColor = UIColor.whiteColor()
        return cell
    }
}

