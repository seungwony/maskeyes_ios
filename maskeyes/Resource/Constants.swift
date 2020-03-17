//
//  Constants.swift
//  maskeyes
//
//  Created by SEUNGWON YANG on 2020/03/12.
//  Copyright © 2020 co.giftree. All rights reserved.
//

import Foundation
struct Constants {
    static let share_group_backup = "group.giftree.co.ormaa"
    static let share_group = "group.giftree.maskeyes"
    static let latitude = "latitude"
    static let longitude = "longitude"
    static let lastKnownLatitude = "lastKnownLatitude"
    static let lastKnownLongitude = "lastKnownLongitude"
    static let meter = 3000
    
    public static var initialUser : Bool {
        get {
           let defaults = UserDefaults.standard
                 
         return defaults.bool(forKey: "initialUser")
        }
        
    }
    public static var enableSmartWidget : Bool {
         get {
             let userDefaults = UserDefaults(suiteName: Constants.share_group)
            
            return userDefaults?.bool(forKey: "enableSW") ?? true
         

         }
         
     }
    
    

    public static var smartWidgetOrder : Int {
            get {
                let userDefaults = UserDefaults(suiteName: Constants.share_group)
               
               return userDefaults?.integer(forKey: "smartwidget_option") ?? 0
            

            }
            
        
    }
    public static var rangeRadius : Int {
            get {
                let userDefaults = UserDefaults(suiteName: Constants.share_group)
               
               return userDefaults?.integer(forKey: "range") ?? 3000
            

            }
            
        
    }
}
