//
//  FirstViewController.swift
//  BikeTO
//
//  Created by Marko Zanoski on 2016-02-09.
//  Copyright © 2016 Marko Zanoski. All rights reserved.
//

import UIKit
import MapKit

class FavoritesViewController: UIViewController, UITableViewDataSource, UIViewControllerWithData 	{

    @IBOutlet weak var skylineImageView: UIImageView!
    @IBOutlet weak var searchStationsButton: UIButton!
    @IBOutlet weak var noFavoritesLabel: UILabel!
    @IBOutlet weak var favoritesTableView: UITableView!
    @IBOutlet weak var favoriteButton: UIButton!
    
//    var data = MockDataSource().data
    internal var data = [StationDataType]()
    let cellIdentifier = "default"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //configure colors
        self.favoritesTableView.separatorColor = UIColor.clearColor() 
    }
    
    override func viewWillAppear(animated: Bool) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        self.data = ApplicationData.Data.items.filter({appDelegate.dataController.hasLocation($0.id, entityType: EntityType.Favorite)})
        
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
        favoritesTableView.reloadData()
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
        
        cell.contentView.viewWithTag(10)!.layer.cornerRadius = 8
        cell.contentView.viewWithTag(10)!.backgroundColor = ApplicationSettings.Settings.theme["baseColorLight"] as! UIColor

        (cell.contentView.viewWithTag(1) as! UILabel).text = item.stationName
        (cell.contentView.viewWithTag(3) as! UILabel).text = "\(item.availableBikes)"
        
        (cell.contentView.viewWithTag(2) as! UIImageView).tintColor = UIColor.greenColor()
        (cell.contentView.viewWithTag(4) as! UIImageView).tintColor = UIColor.greenColor()
        (cell.contentView.viewWithTag(6) as! UILabel).tintColor = UIColor.greenColor()
        
        return cell
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let item = self.data[indexPath.row]
            if appDelegate.dataController.removeLocation(item.id, entityType: EntityType.Favorite) {
            favoritesTableView.beginUpdates()
                self.data.removeAtIndex(indexPath.row)
                favoritesTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                favoritesTableView.endUpdates()
            }
        }
    }
}

