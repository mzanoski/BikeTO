//
//  StationsTableViewDelegate.swift
//  BikeTO
//
//  Created by Marko Zanoski on 2016-03-21.
//  Copyright © 2016 Marko Zanoski. All rights reserved.
//

import Foundation
import UIKit

protocol StationsTableViewProtocol: UITableViewDelegate, UITableViewDataSource {
    var data: [StationDataType] { get }
    var cellIdentifier:String { get }
    func deleteRow(action: UITableViewRowAction, indexPath: NSIndexPath)
    func setTripLocation(action: UITableViewRowAction, indexPath: NSIndexPath)
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]?
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
}

extension StationsTableViewProtocol {
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
        
        //cell.contentView.viewWithTag(10)!.layer.cornerRadius = 8
        
        // set colours
        cell.backgroundColor = (ApplicationSettings.Settings.theme["tableViewBackground"] as! UIColor)
        cell.contentView.viewWithTag(10)!.backgroundColor = (ApplicationSettings.Settings.theme["tableViewBackground"] as! UIColor)
        
        (cell.contentView.viewWithTag(1) as! UILabel).text = item.stationName
        (cell.contentView.viewWithTag(3) as! UILabel).text = "\(item.availableBikes)"
        (cell.contentView.viewWithTag(5) as! UILabel).text = "\(item.availableDocks)"
        
        (cell.contentView.viewWithTag(2) as! UIImageView).tintColor = ApplicationSettings.Settings.theme["parkBadgeColor"] as! UIColor
        (cell.contentView.viewWithTag(4) as! UIImageView).tintColor = ApplicationSettings.Settings.theme["parkBadgeColor"] as! UIColor
        
        
        // test
        if indexPath.row == 2 {
            item.statusValue = "Out of Service"
        }
        
        if item.statusValue.lowercaseString != "in service" {
            (cell.contentView.viewWithTag(21) as! UIImageView).tintColor = ApplicationSettings.Settings.theme["outOfServiceTintColor"] as! UIColor
            (cell.contentView.viewWithTag(20)!).hidden = false
            (cell.contentView.viewWithTag(20)!).alpha = 0.1
            (cell.contentView.viewWithTag(10)!).alpha = 0.4
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