//
//  SecondViewController.swift
//  BikeTO
//
//  Created by Marko Zanoski on 2016-02-16.
//  Copyright © 2016 Marko Zanoski. All rights reserved.
//

import UIKit
import MapKit

class SearchViewController: UIViewController, MKMapViewDelegate {

    internal var data = [StationDataType]()
    let regionRadius: CLLocationDistance = 1000
    var sourceSet: Bool = false
    var destinationSet: Bool = false
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var sourceLocation: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var sourceResetButton: UIButton!
    @IBOutlet weak var sourceFavoriteButton: UIButton!
    @IBOutlet weak var sourceLocationLabel: UILabel!
    var sourceItem: StationDataType?
    
    
    @IBOutlet weak var destinationLocation: UILabel!
    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var destinationResetButton: UIButton!
    @IBOutlet weak var destinationFavoriteButton: UIButton!
    @IBOutlet weak var destinationLocationLabel: UILabel!
    var destinationItem: StationDataType?
    
  
  
    
    @IBOutlet weak var getDirectionsButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let cnTower = CLLocation(latitude: 43.6426, longitude: -79.3871)
        79.3871
        centerMapOnLocation(cnTower)
        mapView.delegate = self
        SetSourceResetButtonVisibility()
        SetDestinationResetButtonVisibility()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        self.data = ApplicationData.Data.items
        mapView.addAnnotations(self.data)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
            regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? StationDataType {
            let identifier = "pin"
            var view: MKPinAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
                as? MKPinAnnotationView {
                    dequeuedView.annotation = annotation
                    view = dequeuedView
            } else {
                let buttonR = UIButton(type: UIButtonType.DetailDisclosure) as UIView
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.rightCalloutAccessoryView = buttonR
            }
            return view
        }
        return nil
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if !sourceSet {
            self.sourceItem = (view.annotation as! StationDataType)
            self.sourceLocationLabel.text = (view.annotation?.title)!
            self.sourceSet = true
            SetSourceResetButtonVisibility()
        }
        else if !destinationSet {
            self.destinationItem = (view.annotation as! StationDataType)
            self.destinationLocationLabel.text = (view.annotation?.title)!
            self.destinationSet = true
            SetDestinationResetButtonVisibility()
        }
    }
    
    
    @IBAction func sourceReset(sender: AnyObject) {
        self.sourceSet = false
        self.sourceItem = nil
        self.sourceLocationLabel.text = nil
        SetSourceResetButtonVisibility()
    }
    
    
    @IBAction func destinationReset(sender: AnyObject) {
        self.destinationSet = false
        self.destinationItem = nil
        self.destinationLocationLabel.text = nil
        SetDestinationResetButtonVisibility()
    }
    
    @IBAction func sourceFavorited(sender: AnyObject) {
        saveLocationItem(EntityType.Favorite, id: sourceItem!.id)
        self.sourceFavoriteButton.hidden = true
    }
    
    @IBAction func destinationFavorited(sender: AnyObject) {
        saveLocationItem(EntityType.Favorite, id: destinationItem!.id)
        self.destinationFavoriteButton.hidden = true
    }
    
    @IBAction func getDirections(sender: AnyObject) {
        saveLocationItem(EntityType.Recent, id: sourceItem!.id)
        saveLocationItem(EntityType.Recent, id: destinationItem!.id)
        
        let regionDistance:CLLocationDistance = 10000
        let regionSpan = MKCoordinateRegionMakeWithDistance(sourceItem!.coordinate, regionDistance, regionDistance)
        let options = [
            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking,
            MKLaunchOptionsMapCenterKey: NSValue(MKCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(MKCoordinateSpan: regionSpan.span)
        ]
        
        let sourcePlacemark = MKPlacemark(coordinate: sourceItem!.coordinate, addressDictionary: nil)
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        sourceMapItem.name = sourceLocation.text
        
        let destinationPlacemark = MKPlacemark(coordinate: destinationItem!.coordinate, addressDictionary: nil)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        destinationMapItem.name = destinationLocation.text
        
        MKMapItem.openMapsWithItems([sourceMapItem, destinationMapItem], launchOptions: options)
    }
    
    func saveLocationItem(entityType: EntityType, id: Int){
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.dataController.addLocation(id, entityType: entityType)
    }
    
    func locationItemSaved(entityType: EntityType, id: Int) -> Bool{
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        return appDelegate.dataController.hasLocation(id, entityType: entityType)
    }
    
    func SetSourceResetButtonVisibility(){
        if self.sourceSet {
            self.sourceLabel.hidden = false
            self.sourceResetButton.hidden = false
            
            if locationItemSaved(EntityType.Favorite, id: self.sourceItem!.id) {
                self.sourceFavoriteButton.hidden = true
            }
            else{
                self.sourceFavoriteButton.hidden = false
            }
            
            if self.destinationSet {
                self.getDirectionsButton.enabled = true
            }
        }
        else{
            self.sourceLabel.hidden = true
            self.sourceResetButton.hidden = true
            self.sourceFavoriteButton.hidden = true
            self.getDirectionsButton.enabled = false
        }
    }
    
    func SetDestinationResetButtonVisibility(){
        if self.destinationSet {
            self.destinationLabel.hidden = false
            self.destinationResetButton.hidden = false
            
            if locationItemSaved(EntityType.Favorite, id: self.destinationItem!.id) {
                self.destinationFavoriteButton.hidden = true
            }
            else{
                self.destinationFavoriteButton.hidden = false
            }
            
            if self.sourceSet {
                self.getDirectionsButton.enabled = true
            }
        }
        else{
            self.destinationLabel.hidden = true
            self.destinationResetButton.hidden = true
            self.destinationFavoriteButton.hidden = true
            self.getDirectionsButton.enabled = false
        }
    }
}

