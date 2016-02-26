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
    
    private init(){
        self.theme["baseColor"] = UIColor(red: 52/255, green: 100/255, blue: 136/255, alpha: 1)
        self.theme["baseColorLight"] = UIColor(red: 52/255, green: 100/255, blue: 136/255, alpha: 0.15)
    }
}
//R: 52 G: 100 B: 136
