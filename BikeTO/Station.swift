//
//  Station.swift
//  BikeTO
//
//  Created by Marko Zanoski on 2016-02-13.
//  Copyright © 2016 Marko Zanoski. All rights reserved.
//

import Foundation
import MapKit

protocol StationDataType: MKAnnotation {
    var id: Int { get}
    var stationName: String { get}
    var availableDocks: Int { get}
    var totalDocks: Int { get}
    var latitude: Double { get}
    var longitude: Double { get}
    var coordinate: CLLocationCoordinate2D { get }
    var statusValue: String { get}
    var statusKey: Int { get}
    var availableBikes: Int { get}
    var stAddress1: String? { get}
    var stAddress2: String? { get}
    var city: String? { get}
    var postalCode: String? { get}
    var location: String? { get}
    var altitude: String? { get}
    var testStation: Bool { get}
    var lastCommunicationTime: NSDate { get}
    var landMark: Int { get}
}

class MockStation: NSObject, StationDataType {
    let id: Int                         = 1
    let stationName: String             = "Jarvis St \\/ Carlton St"
    let availableDocks: Int             = 6
    let totalDocks: Int                 = 14
    let latitude: Double                = 43.66207
    let longitude: Double               = -79.37617
    let coordinate: CLLocationCoordinate2D
    let statusValue: String             = "In Service"
    let statusKey: Int                  = 1
    let availableBikes: Int             = 8
    let stAddress1: String?             = nil
    let stAddress2: String?             = nil
    let city: String?                   = nil
    let postalCode: String?             = nil
    let location: String?               = nil
    let altitude: String?               = nil
    let testStation: Bool               = false
    let lastCommunicationTime: NSDate
    let landMark: Int                   = 7055
    
    override init(){
        let dateAsString = "2016-02-13 12:46:17 PM"
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss a"
        self.lastCommunicationTime = dateFormatter.dateFromString(dateAsString)!
        self.coordinate = CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
    }
}

class Station: NSObject, StationDataType {
    let id: Int                         //1,
    let stationName: String             //Jarvis St \/ Carlton St",
    let availableDocks: Int             //6,
    let totalDocks: Int                 // 14,
    let latitude: Double                //43.66207,
    let longitude: Double               // -79.37617,
    let coordinate: CLLocationCoordinate2D
    let statusValue: String             // "In Service",
    let statusKey: Int                  // 1,
    let availableBikes: Int             // 8,
    let stAddress1: String? = nil       // null,
    let stAddress2: String? = nil       //null,
    let city: String? = nil             // null,
    let postalCode: String? = nil       //null,
    let location: String? = nil         //null,
    let altitude: String? = nil         //null,
    let testStation: Bool               //false,
    let lastCommunicationTime: NSDate   // "2016-02-13 12:46:17 PM",
    let landMark: Int                   //7055
    
    init(id: Int, stationName: String, availableDocks: Int, totalDocks: Int, latitude: Double, longitude: Double, statusValue: String, statusKey: Int, availableBikes: Int, lastCommunicationTime: NSDate, landMark: Int, testStation: Bool){
        
        self.id = id
        self.stationName = stationName
        self.latitude = latitude
        self.longitude = longitude
        self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        self.statusValue = statusValue
        self.statusKey = statusKey
        self.landMark = landMark
        self.lastCommunicationTime = lastCommunicationTime
        self.testStation = testStation
        
        self.availableDocks = availableDocks
        self.totalDocks = totalDocks
        self.availableBikes = availableBikes
    }
}