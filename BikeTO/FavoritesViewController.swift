//
//  FirstViewController.swift
//  BikeTO
//
//  Created by Marko Zanoski on 2016-02-09.
//  Copyright © 2016 Marko Zanoski. All rights reserved.
//

import UIKit
import MapKit

class FirstViewController: UIViewController, UITableViewDataSource 	{

    @IBOutlet weak var searchStationsButton: UIButton!
    @IBOutlet weak var noFavoritesLabel: UILabel!
    @IBOutlet weak var favoritesTableView: UITableView!
    var data = MockDataSource().data
    let cellIdentifier = "default"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //data.removeAll()
        
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
        
//        cell.layer.borderColor = UIColor.blackColor().CGColor
//        cell.layer.borderWidth = 1.0
        
        (cell.contentView.viewWithTag(1) as! UILabel).text = item.stationName
        (cell.contentView.viewWithTag(3) as! UILabel).text = "\(item.availableBikes)"
        
        (cell.contentView.viewWithTag(2) as! UIImageView).tintColor = UIColor.greenColor()
        (cell.contentView.viewWithTag(4) as! UIImageView).tintColor = UIColor.greenColor()
        (cell.contentView.viewWithTag(6) as! UIImageView).tintColor = UIColor.greenColor()
        
        let region = MKCoordinateRegionMakeWithDistance(item.coordinate,  2000, 2000)
        (cell.contentView.viewWithTag(7) as! MKMapView).setRegion(region, animated: false)
        (cell.contentView.viewWithTag(7) as! MKMapView).addAnnotation(item)

        
       // (cell.contentView.viewWithTag(5) as! UILabel).text = "\(item.availableDocks)"
        
//        cell.textLabel?.text = item.stationName
//        cell.detailTextLabel?.text = "Status: \(item.statusValue)"
        
        return cell
    }
    
    // MARK:  UITableViewDelegate Methods
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let row = indexPath.row
        print(data[row])
    }


}

