//
//  MockData.swift
//  BikeTO
//
//  Created by Marko Zanoski on 2016-02-09.
//  Copyright © 2016 Marko Zanoski. All rights reserved.
//

import Foundation

struct MockDataSource {
    var data: [MockStation] = Array() 
    
    init(){
        for _ in 1...10 {
            let s = MockStation()
            data.append(s)
        }
    }
}

