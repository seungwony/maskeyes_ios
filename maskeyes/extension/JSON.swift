//
//  JSON.swift
//  maskeyes
//
//  Created by SEUNGWON YANG on 2020/03/12.
//  Copyright © 2020 co.giftree. All rights reserved.
//

import Foundation
import SwiftyJSON

extension JSON {
    
    func convertIntToString() -> String{
        
        if self.type == Type.number {
            let str = "\(self.int as Any)"
            return str
        }
        
        return ""
    }
    
    func safeParseString() -> String{
        if self.type == Type.string {
            let str = self.string != nil ? self.string : ""
            return str!
        }
        
        return ""
    }
    
    var easyString:  String {
        switch self.type {
        case .string:
            let str = self.string != nil ? self.string : ""
            return str!
            
        case .number:
            
            
            
            let str = "\(self.int! as Any)"
            return str
        case .bool:
            let str = "\(self.bool! as Any)"
            return str
        default:
            return ""
        }
    }
    
    var easyStringNumber:  String {
        switch self.type {
        case .string:
            let str = self.string != nil ? self.string : "0"
            return str!

      
        default:
            return "0"
        }
    }
    
    
    var floatFirstString : String {
        switch self.type {
        case .string:
            let str = self.string != nil ? self.string : ""
            return str!
            
        case .number:
            
            let str = String(format: "%.1f", self.float!)
            //                let str = "\(self.int! as Any)"
            return str
        default:
            return ""
        }
    }
    
    
}
