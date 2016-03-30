//
//  ApplicationSettings.swift
//  BikeTO
//
//  Created by Marko Zanoski on 2016-02-17.
//  Copyright © 2016 Marko Zanoski. All rights reserved.
//

import Foundation
import UIKit

//enum Theme {
//    case baseColor = UIColor(red: 52/255, green: 100/255, blue: 136/255, alpha: 1)
//}

class ApplicationSettings {
    static let Settings = ApplicationSettings()
    var theme = Dictionary<String, Any>()
    var sourceItem: StationDataType?
    var destinationItem: StationDataType?
    
    private init(){
        self.theme["baseColor"] = UIColor(red: 70/255, green: 137/255, blue: 187/255, alpha: 1)
        self.theme["baseColorLight"] = UIColor(red: 96/255, green: 187/255, blue: 255/255, alpha: 1)
        self.theme["accentColor"] = UIColor(red: 52/255, green: 100/255, blue: 136/255, alpha: 1)
        self.theme["parkBadgeColor"] = UIColor(red: 52/255, green: 100/255, blue: 136/255, alpha: 1)
        self.theme["startCellBackgrondColor"] = UIColor(red: 0/255, green: 255/255, blue: 0/255, alpha: 0.3)
        self.theme["destinationCellBackgrondColor"] = UIColor(red: 153/255, green: 153/255, blue: 153/255, alpha: 0.5)
        self.theme["unselectedCellBackgroundColor"] = UIColor.clearColor()
        self.theme["goBikeTabBarItemEnabledColor"] = UIColor.orangeColor()
        self.theme["tabBarTintColor"] = UIColor.orangeColor()
        self.theme["outOfServiceTintColor"] = UIColor.redColor()
        self.theme["tableViewBackground"] = UIColor.clearColor()
    }
    
    
}
//R: 52 G: 100 B: 136
