//
//  SecondViewController.swift
//  BikeTO
//
//  Created by Marko Zanoski on 2016-02-16.
//  Copyright © 2016 Marko Zanoski. All rights reserved.
//

import UIKit
import MapKit

class SearchViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource {

    internal var data = [StationDataType]()
    var choosenStations = [StationDataType]()
    let cellIdentifier = "default"
    let regionRadius: CLLocationDistance = 1000
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var stationsTableView: UITableView!
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.stationsTableView.delegate = self
        self.stationsTableView.dataSource = self

        locationManager.delegate = self
        
        let appDelegate = UIApplication.sharedApplication().delegate!
        appDelegate.setBackgroundGradientForView(self.view)
    
        mapView.delegate = self
        
        checkLocationAuthorizationStatus()
        
        if let centerLocation = locationManager.location{
            centerMapOnLocation(centerLocation)
        }
        else{
            let cnTower = CLLocation(latitude: 43.6426, longitude: -79.3871)
            centerMapOnLocation(cnTower)
        }
        setDirectionsTabBarItemEnabled()
    }
    
    func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse {
            locationManager.startUpdatingLocation()
            mapView.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }

    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0]
        //centerMapOnLocation(userLocation)
    }
    
    override func viewWillAppear(animated: Bool) {
        self.data = ApplicationData.Data.items
        mapView.addAnnotations(self.data)
        choosenStations = [StationDataType]()
        if let si = ApplicationSettings.Settings.sourceItem{
            choosenStations.append(si)
        }
        if let di = ApplicationSettings.Settings.destinationItem {
            choosenStations.append(di)
        }
        stationsTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
            regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? StationDataType {
            let identifier = "pin"
            var view: MKAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier){
                    dequeuedView.annotation = annotation
                    view = dequeuedView
            } else {
                let startButton = UIButton(type: UIButtonType.DetailDisclosure)
                let wImage = UIImage(named: "wheel_icon_44")
                startButton.setImage(wImage, forState: .Normal)
                startButton.frame.size.width = 50
                startButton.frame.size.height = 50
                startButton.backgroundColor = (ApplicationSettings.Settings.theme["startCellBackgrondColor"] as! UIColor)
                startButton.tag = 10
                
                let finishButton = UIButton(type: UIButtonType.DetailDisclosure)
                let pImage = UIImage(named: "park_icon_44")
                finishButton.setImage(pImage, forState: .Normal)
                finishButton.frame.size.width = 50
                finishButton.frame.size.height = 50
                finishButton.backgroundColor = (ApplicationSettings.Settings.theme["destinationCellBackgrondColor"] as! UIColor)
                finishButton.tag = 20
                
                view = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: 0, y: 0)
                view.rightCalloutAccessoryView = finishButton
                view.leftCalloutAccessoryView = startButton
                view.image = UIImage(named: "wheel_icon_44")
            }
            return view
        }
        return nil
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        // left/start button
        if control.tag == 10 {
            self.addSourceItemToChoosenStationsDataSet((view.annotation as? StationDataType)!)
            setDirectionsTabBarItemEnabled()
        }
        // right/finish button
        else if control.tag == 20 {
            self.addDestinationItemToChoosenStationsDataSet((view.annotation as? StationDataType)!)
            setDirectionsTabBarItemEnabled()
        }
    }
    
    func addSourceItemToChoosenStationsDataSet(item: StationDataType){
        var itemToRemove = ApplicationSettings.Settings.sourceItem
        ApplicationSettings.Settings.sourceItem = item
        
        if (itemToRemove != nil) {
            self.choosenStations = self.choosenStations.filter({
                $0.id != itemToRemove?.id
            })
        }
        
        if item.id == ApplicationSettings.Settings.destinationItem?.id{
            itemToRemove = ApplicationSettings.Settings.destinationItem
            ApplicationSettings.Settings.destinationItem = nil
        }
        
        if (itemToRemove != nil) {
            self.choosenStations = self.choosenStations.filter({
                $0.id != itemToRemove?.id
            })
        }
        
        self.choosenStations.append(item)
        self.stationsTableView.reloadData()
        self.stationsTableView.setNeedsDisplay()
    }
    
    func addDestinationItemToChoosenStationsDataSet(item: StationDataType){
        var itemToRemove = ApplicationSettings.Settings.destinationItem
        ApplicationSettings.Settings.destinationItem = item
        
        if (itemToRemove != nil) {
            self.choosenStations = self.choosenStations.filter({
                $0.id != itemToRemove?.id
            })
        }
        
        if item.id == ApplicationSettings.Settings.sourceItem?.id{
            itemToRemove = ApplicationSettings.Settings.sourceItem
            ApplicationSettings.Settings.sourceItem = nil
        }
        
        if (itemToRemove != nil) {
            self.choosenStations = self.choosenStations.filter({
                $0.id != itemToRemove?.id
            })
        }
        
        self.choosenStations.append(item)
        self.stationsTableView.reloadData()
        self.stationsTableView.setNeedsDisplay()
    }
    
    func saveLocationItem(entityType: EntityType, id: Int){
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.dataController.addLocation(id, entityType: entityType)
    }
    
    func locationItemSaved(entityType: EntityType, id: Int) -> Bool{
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        return appDelegate.dataController.hasLocation(id, entityType: entityType)
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
        let item = self.choosenStations[indexPath.row]
        stationsTableView.beginUpdates()
    
        self.choosenStations = self.choosenStations.filter({
            $0.id != item.id
        })
        
        stationsTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        self.stationsTableView.cellForRowAtIndexPath(indexPath)?.contentView.viewWithTag(0)!.backgroundColor = UIColor.clearColor()
        stationsTableView.endUpdates()

        if ApplicationSettings.Settings.sourceItem?.id == item.id {
            ApplicationSettings.Settings.sourceItem = nil
        }
        
        if ApplicationSettings.Settings.destinationItem?.id == item.id {
            ApplicationSettings.Settings.destinationItem = nil
        }
        setDirectionsTabBarItemEnabled()
    }

    // MARK: UITableView stuff
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return choosenStations.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as UITableViewCell
        
        let row = indexPath.row
        let item = choosenStations[row] as StationDataType
        
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
        (cell.contentView.viewWithTag(0)!).backgroundColor = (ApplicationSettings.Settings.theme["unselectedCellBackgroundColor"] as! UIColor)
        if ApplicationSettings.Settings.sourceItem?.id == item.id {
            (cell.contentView.viewWithTag(0)!).backgroundColor = (ApplicationSettings.Settings.theme["startCellBackgrondColor"] as! UIColor)
        }
        if ApplicationSettings.Settings.destinationItem?.id == item.id {
            (cell.contentView.viewWithTag(0)!).backgroundColor = (ApplicationSettings.Settings.theme["destinationCellBackgrondColor"] as! UIColor)
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .Default, title: "Remove", handler: self.deleteRow)
        
        let item = choosenStations[indexPath.row]
        if !locationItemSaved(.Favorite, id: item.id) {
            let favoriteAction = UITableViewRowAction(style: .Normal, title: "Favorite", handler: self.stationFavorited)
            favoriteAction.backgroundColor = UIColor.grayColor()
            return [deleteAction, favoriteAction]
        }
        return [deleteAction]
    }
    
    func stationFavorited(rowAction: UITableViewRowAction, indexPath: NSIndexPath) {
        let item = choosenStations[indexPath.row]
        saveLocationItem(EntityType.Favorite, id: item.id)
        self.stationsTableView.editing = false
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    }


// FOR REFERENCE
//    func SetDestinationResetButtonVisibility(){
//        if self.destinationSet {
//            self.destinationLabel.hidden = false
//            self.destinationResetButton.hidden = false
//            
//            if locationItemSaved(EntityType.Favorite, id: self.destinationItem!.id) {
//                self.destinationFavoriteButton.hidden = true
//            }
//            else{
//                self.destinationFavoriteButton.hidden = false
//            }
//            
//            if self.sourceSet {
//                self.getDirectionsButton.enabled = true
//                (self.tabBarController!.tabBar.items![2] as UITabBarItem).enabled = true
//            }
//        }
//        else{
//            self.destinationLabel.hidden = true
//            self.destinationResetButton.hidden = true
//            self.destinationFavoriteButton.hidden = true
//            self.getDirectionsButton.enabled = false
//            (self.tabBarController!.tabBar.items![2] as UITabBarItem).enabled = false
//        }
//    }
    
//    @IBAction func destinationFavorited(sender: AnyObject) {
//        saveLocationItem(EntityType.Favorite, id: destinationItem!.id)
//        self.destinationFavoriteButton.hidden = true
//    }
    
//    @IBAction func getDirections(sender: AnyObject) {
//        saveLocationItem(EntityType.Recent, id: sourceItem!.id)
//        saveLocationItem(EntityType.Recent, id: destinationItem!.id)
//
//        let regionDistance:CLLocationDistance = 10000
//        let regionSpan = MKCoordinateRegionMakeWithDistance(sourceItem!.coordinate, regionDistance, regionDistance)
//        let options = [
//            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking,
//            MKLaunchOptionsMapCenterKey: NSValue(MKCoordinate: regionSpan.center),
//            MKLaunchOptionsMapSpanKey: NSValue(MKCoordinateSpan: regionSpan.span)
//        ]
//
//        let sourcePlacemark = MKPlacemark(coordinate: sourceItem!.coordinate, addressDictionary: nil)
//        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
//        sourceMapItem.name = sourceLocation.text
//
//        let destinationPlacemark = MKPlacemark(coordinate: destinationItem!.coordinate, addressDictionary: nil)
//        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
//        destinationMapItem.name = destinationLocation.text
//
//        MKMapItem.openMapsWithItems([sourceMapItem, destinationMapItem], launchOptions: options)
//    }

}

