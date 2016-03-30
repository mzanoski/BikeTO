//
//  RecentViewController.swift
//  BikeTO
//
//  Created by Marko Zanoski on 2016-02-09.
//  Copyright © 2016 Marko Zanoski. All rights reserved.
//

import UIKit
import MapKit

class DirectionsViewController: UIViewController	{
    @IBOutlet weak var mapView: MKMapView!
    
    let regionRadius: CLLocationDistance = 1000
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let appDelegate = UIApplication.sharedApplication().delegate!
        appDelegate.setBackgroundGradientForView(self.view)
    }
    
    override func viewWillAppear(animated: Bool) {
        getDirections()
    }
    
    func getDirections(){
        let regionSpan = MKCoordinateRegionMakeWithDistance(ApplicationSettings.Settings.sourceItem!.coordinate, regionRadius, regionRadius)
        let options = [
            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking,
            MKLaunchOptionsMapCenterKey: NSValue(MKCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(MKCoordinateSpan: regionSpan.span)
        ]
        
        let sourcePlacemark = MKPlacemark(coordinate: ApplicationSettings.Settings.sourceItem!.coordinate, addressDictionary: nil)
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        sourceMapItem.name = ApplicationSettings.Settings.sourceItem?.stationName
        
        let destinationPlacemark = MKPlacemark(coordinate: ApplicationSettings.Settings.destinationItem!.coordinate, addressDictionary: nil)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        destinationMapItem.name = ApplicationSettings.Settings.destinationItem!.stationName
        
        MKMapItem.openMapsWithItems([sourceMapItem, destinationMapItem], launchOptions: options)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

