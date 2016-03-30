//
//  Station.swift
//  BikeTO
//
//  Created by Marko Zanoski on 2016-02-13.
//  Copyright © 2016 Marko Zanoski. All rights reserved.
//

import Foundation

public class ApplicationData {
    static let Data = ApplicationData()
    static let url = NSURL(string: "http://www.bikesharetoronto.com/stations/json")
    var items:[StationDataType]
    
    init(){
        self.items = [StationDataType]()
        let feedUrl = ApplicationData.url
        updateFeed(feedUrl!)
    }
    
    func updateFeed(url: NSURL) -> Void {
        let request = NSURLRequest(URL: url)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) -> Void in
            if error == nil && data != nil {
                let feed = Feed(data: data!)
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    if let items = feed?.items {
                        self.items = items
                    }
                })
            }
            
        }
        task.resume()
    }
}

func fixJsonData (data: NSData) -> NSData {
    var dataString = String(data: data, encoding: NSUTF8StringEncoding)!
    dataString = dataString.stringByReplacingOccurrencesOfString("\\'", withString: "'")
    dataString = dataString.stringByReplacingOccurrencesOfString("\\/", withString: "&")
    return dataString.dataUsingEncoding(NSUTF8StringEncoding)!
    
}

class Feed {
    let items: [Station]
    
    init (items newItems: [Station]) {
        self.items = newItems
    }
    
    convenience init? (data: NSData?) {
        
        var newItems = [Station]()
        
        if data == nil {
            self.init(items: Array<Station>())
        }
        else{
            let fixedData = fixJsonData(data!)
            
            var jsonObject: Dictionary<String, AnyObject>?
            
            do {
                jsonObject = try NSJSONSerialization.JSONObjectWithData(fixedData, options: NSJSONReadingOptions(rawValue: 0)) as? Dictionary<String,AnyObject>
            } catch {
                
            }
            
            guard let feedRoot = jsonObject else {
                return nil
            }
            
            guard let items = feedRoot["stationBeanList"] as? Array<AnyObject>  else {
                return nil
            }
            
            
            for item in items {
                
                guard let itemDict = item as? Dictionary<String,AnyObject> else {
                    continue
                }
                guard let id = itemDict["id"] as? Int else {
                    continue
                }
                
                guard let stationName = itemDict["stationName"] as? String else{
                    continue
                }
                
                guard let availableDocks = itemDict["availableDocks"] as? Int else{
                    continue
                }
                
                guard let totalDocks = itemDict["totalDocks"] as? Int else{
                    continue
                }
                
                guard let latitude = itemDict["latitude"] as? Double else{
                    continue
                }
                
                guard let longitude = itemDict["longitude"] as? Double else{
                    continue
                }
                
                guard let statusValue = itemDict["statusValue"] as? String else{
                    continue
                }
                
                guard let statusKey = itemDict["statusKey"] as? Int else{
                    continue
                }
                
                guard let availableBikes = itemDict["availableBikes"] as? Int else{
                    continue
                }
                
                guard let lastCommunicationTime = itemDict["lastCommunicationTime"] as? String else{
                    continue
                }
                
                guard let landMark = itemDict["landMark"] as? Int else{
                    continue
                }
                
                guard let testStation = itemDict["testStation"] as? Bool else{
                    continue
                }
                
                newItems.append(Station(id: id, stationName: stationName, availableDocks: availableDocks, totalDocks: totalDocks, latitude: latitude, longitude: longitude, statusValue: statusValue, statusKey: statusKey, availableBikes: availableBikes, lastCommunicationTime: lastCommunicationTime, landMark: landMark, testStation: testStation))
                
            }
            
            self.init(items: newItems)
        }
    }
    
}