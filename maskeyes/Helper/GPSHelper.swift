//
//  GPSHelper.swift
//  maskeyes
//
//  Created by SEUNGWON YANG on 2020/03/13.
//  Copyright © 2020 co.giftree. All rights reserved.
//


import CoreLocation


class GPSHelper {
    class func distanceWithKilometer(lat:Double, lng:Double, clat:Double, clng:Double) -> String{

        let coordinate₀ = CLLocation(latitude: lat, longitude: lng)
        let coordinate₁ = CLLocation(latitude: clat, longitude: clng)

        let distanceInMeters = coordinate₀.distance(from: coordinate₁) // result is in meters
        let distance = distanceInMeters / 1000

        
        return String(format: "%.01fkm", distance)
    }
    
    class func distance(lat:Double, lng:Double, clat:Double, clng:Double) -> Int{

        let coordinate₀ = CLLocation(latitude: lat, longitude: lng)
        let coordinate₁ = CLLocation(latitude: clat, longitude: clng)

        let distanceInMeters = coordinate₀.distance(from: coordinate₁) // result is in meters
        let distance = distanceInMeters

        
        return Int(distance)
    }
}
