//
//  Address.swift
//  maskeyes
//
//  Created by SEUNGWON YANG on 2020/03/13.
//  Copyright © 2020 co.giftree. All rights reserved.
//

import Foundation

struct AddressInfo {
    
    let lat:Double
    let lng:Double
    let address:String
    init(lat:Double, lng:Double, address:String) {
        
        self.lat = lat
        self.lng = lng
        self.address = address
    }
    
}
