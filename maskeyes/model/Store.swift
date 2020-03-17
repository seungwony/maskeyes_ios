//
//  MaskInfo.swift
//  maskeyes
//
//  Created by SEUNGWON YANG on 2020/03/12.
//  Copyright © 2020 co.giftree. All rights reserved.
//

import Foundation

struct Store {

    

    let name : String
    let code : String
    let addr : String
    
    let lat:Float
    let lng:Float
    
    let type : String
    let remain_stat : String
    
    let stock_at : String
    let created_at : String
    
    var distance:Int?
    var disStr:String?
    
    init(name:String, code:String, addr:String, lat:Float, lng:Float, type:String, remain_stat:String, stock_at:String, created_at:String) {
        self.name = name
        self.code = code
        self.addr = addr
        
        self.lat = lat
        self.lng = lng
        
        self.type = type
        self.remain_stat = remain_stat
        
        self.stock_at = stock_at
        self.created_at = created_at
    }
    
}
