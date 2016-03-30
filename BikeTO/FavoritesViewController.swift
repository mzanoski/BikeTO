//
//  FirstViewController.swift
//  BikeTO
//
//  Created by Marko Zanoski on 2016-02-09.
//  Copyright © 2016 Marko Zanoski. All rights reserved.
//

import UIKit
import MapKit

class FavoritesViewController: UIViewController, UIViewControllerWithData, UITableViewDataSource, UITableViewDelegate{

    @IBOutlet weak var searchStationsButton: UIButton!
    @IBOutlet weak var noFavoritesLabel: UILabel!
    @IBOutlet weak var favoritesTableView: UITableView!
    
    var startIndexPath: NSIndexPath?
    var destinationIndexPath: NSIndexPath?
    let cellIdentifier = "default"
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

    internal var data = [StationDataType]() {
        didSet{
            setViewVisibility()
            self.favoritesTableView.reloadData()
        }
    }
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "handleRefresh:", forControlEvents: UIControlEvents.ValueChanged)
        
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //configure colors
        self.favoritesTableView.separatorColor = (ApplicationSettings.Settings.theme["baseColor"] as! UIColor)
        appDelegate.setBackgroundGradientForView(self.view)
        self.favoritesTableView.delegate = self
        self.favoritesTableView.addSubview(refreshControl)
        loadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.favoritesTableView.reloadData()
        setViewVisibility()
    }
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        loadData()
        refreshControl.endRefreshing()
    }
    
    func loadData(){
        appDelegate.updateFeed(ApplicationData.url!, completion: {(feed) -> Void in
            if let items = feed?.items {
                ApplicationData.Data.items = items
                self.data = ApplicationData.Data.items.filter({self.appDelegate.dataController.hasLocation($0.id, entityType: EntityType.Favorite)})
            }
        })
    }
    
    func setViewVisibility(){
        if data.count > 0 {
            favoritesTableView.dataSource = self
            favoritesTableView.hidden = false
            
            noFavoritesLabel.hidden = true
            searchStationsButton.hidden = true
        }
        else{
            favoritesTableView.hidden = true
            
            noFavoritesLabel.hidden = false
            searchStationsButton.hidden = false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func searchForBikeStations(sender: AnyObject) {
        self.tabBarController?.selectedViewController = self.tabBarController?.viewControllers![1]
    }
    
    func setTripLocation(action: UITableViewRowAction, indexPath: NSIndexPath){
        if action.title == "Start" {
            ApplicationSettings.Settings.sourceItem = data[indexPath.row]
            startIndexPath = indexPath
            
            if startIndexPath == destinationIndexPath {
                destinationIndexPath = nil
                ApplicationSettings.Settings.destinationItem = nil
            }
            
        }
        else if action.title == "Finish" {
            ApplicationSettings.Settings.destinationItem = data[indexPath.row]
            destinationIndexPath = indexPath
            
            if destinationIndexPath == startIndexPath {
                startIndexPath = nil
                ApplicationSettings.Settings.sourceItem = nil
            }
        }
        self.favoritesTableView.setEditing(false, animated: true)
        self.favoritesTableView.reloadData()
        self.favoritesTableView.setNeedsDisplay()
        setDirectionsTabBarItemEnabled()
    }
    
    func setDirectionsTabBarItemEnabled(){
        if ApplicationSettings.Settings.sourceItem != nil && ApplicationSettings.Settings.destinationItem != nil {
            (self.tabBarController!.tabBar.items![2] as UITabBarItem).enabled = true
        }
        else{
            (self.tabBarController!.tabBar.items![2] as UITabBarItem).enabled = false
        }
    }
    
    func deleteRow(action: UITableViewRowAction, indexPath: NSIndexPath){
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let item = self.data[indexPath.row]
        if appDelegate.dataController.removeLocation(item.id, entityType: EntityType.Favorite) {
            favoritesTableView.beginUpdates()
            self.data.removeAtIndex(indexPath.row)
            favoritesTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            self.favoritesTableView.cellForRowAtIndexPath(indexPath)?.contentView.viewWithTag(0)!.backgroundColor = UIColor.clearColor()
            favoritesTableView.endUpdates()
        }
        
        if startIndexPath == indexPath {
            startIndexPath = nil
            ApplicationSettings.Settings.sourceItem = nil
        }
        
        if destinationIndexPath == indexPath {
            destinationIndexPath = nil
            ApplicationSettings.Settings.destinationItem = nil
        }
        setDirectionsTabBarItemEnabled()
    }
    
    // MARK: UITableView stuff
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
        
        // set colours
        cell.backgroundColor = (ApplicationSettings.Settings.theme["tableViewBackground"] as! UIColor)
        cell.contentView.viewWithTag(10)!.backgroundColor = (ApplicationSettings.Settings.theme["tableViewBackground"] as! UIColor)
        
        (cell.contentView.viewWithTag(1) as! UILabel).text = item.stationName
        (cell.contentView.viewWithTag(3) as! UILabel).text = "\(item.availableBikes)"
        (cell.contentView.viewWithTag(5) as! UILabel).text = "\(item.availableDocks)"
        
        (cell.contentView.viewWithTag(2) as! UIImageView).tintColor = ApplicationSettings.Settings.theme["parkBadgeColor"] as! UIColor
        (cell.contentView.viewWithTag(4) as! UIImageView).tintColor = ApplicationSettings.Settings.theme["parkBadgeColor"] as! UIColor
        
        if item.statusValue.lowercaseString != "in service" {
            (cell.contentView.viewWithTag(21) as! UIImageView).tintColor = ApplicationSettings.Settings.theme["outOfServiceTintColor"] as! UIColor
            (cell.contentView.viewWithTag(20)!).hidden = false
            (cell.contentView.viewWithTag(20)!).alpha = 0.1
            (cell.contentView.viewWithTag(10)!).alpha = 0.4
        }
        
        // check if this item is selected as source or desitnation item
        if ApplicationSettings.Settings.sourceItem?.id == item.id {
            (cell.contentView.viewWithTag(0)!).backgroundColor = (ApplicationSettings.Settings.theme["startCellBackgrondColor"] as! UIColor)
        }
        else if ApplicationSettings.Settings.destinationItem?.id == item.id {
            (cell.contentView.viewWithTag(0)!).backgroundColor = (ApplicationSettings.Settings.theme["destinationCellBackgrondColor"] as! UIColor)
        }
        else {
            (cell.contentView.viewWithTag(0)!).backgroundColor = (ApplicationSettings.Settings.theme["unselectedCellBackgroundColor"] as! UIColor)
        }
        return cell
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let startAction = UITableViewRowAction(style: .Normal, title: "Start", handler: self.setTripLocation)
        startAction.backgroundColor = UIColor.greenColor()
        
        let destinationAction = UITableViewRowAction(style: .Normal, title: "Finish", handler: self.setTripLocation)
        destinationAction.backgroundColor = UIColor.grayColor()
        
        let deleteAction = UITableViewRowAction(style: .Default, title: "Delete", handler: self.deleteRow)
        
        if data[indexPath.row].statusValue == "In Service"{
            return [deleteAction, destinationAction, startAction]
        }
        return [deleteAction]
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    }

}

