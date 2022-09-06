//
//  ApiHelper.swift
//  maskeyes
//
//  Created by SEUNGWON YANG on 2020/03/13.
//  Copyright © 2020 co.giftree. All rights reserved.
//


import Alamofire
import SwiftyJSON
import UIKit
protocol ConnDelegate {

    func succ(stores : [Store] )
    
    func failed(error:String)
}
class ApiHelper {

          
    class func storesByGeo(targetlat:Double, targetlng:Double, currLat:Double, currLng:Double, delegate:ConnDelegate, hideEmpty:Bool = false){
            
        debugPrint("lat:\(targetlat) lng:\(targetlng) range:\(Constants.rangeRadius)")
        
        Alamofire.request(Router.storesByGeo(lat: targetlat, lng:targetlng, m:Constants.rangeRadius))
                   .responseJSON { response in
                       
                       
//                       debugPrint(response.result.description)
                   switch response.result {
                   case .success:
                    
                        var tmpStores : [Store] = []
                        
                        
                       if let data = response.result.value as? [String: Any] {
                           
                           let json = JSON(data)
                           
    //                           debugPrint("===getMainPackList===")
                               debugPrint(json)

                           if let stores = json["stores"].array {

                            if stores.count == 0 {
                                
                            }
                            
                            
                                for store in stores{

                                
                                    let code = store["code"].easyString
                                    let name = store["name"].easyString
                                    let addr = store["addr"].easyString
                                    
                                    let type = store["type"].easyString
                                    let remain_stat = store["remain_stat"].easyString
                                    
                                    let stock_at = store["stock_at"].easyString
                                    let created_at = store["created_at"].easyString
                                    
                                    let lat = store["lat"].float ?? 0.0
                                    let lng = store["lng"].float ?? 0.0
                                    
                                    
                                    var maskStore = Store(name: name, code: code, addr: addr, lat: lat, lng: lng, type: type, remain_stat: remain_stat, stock_at: stock_at, created_at: created_at)
    //                                        self.items.append(filterPack)
                                    
                                    maskStore.distance = GPSHelper.distance(lat: Double(lat), lng: Double(lng), clat: currLat, clng: currLng)
                                    
                                    maskStore.disStr = GPSHelper.distanceWithKilometer(lat: Double(lat), lng: Double(lng), clat: currLat, clng: currLng)
                                    
                                    
                                    if hideEmpty && remain_stat == "empty"{
                                        
                                    }else{
                                        tmpStores.append(maskStore)
                                    }
                                }
                            }
                       }
                        delegate.succ(stores: tmpStores)
                       
                    break
                                  
                   case .failure(let error):
                                       
                    print("error : \(error)")
                    delegate.failed(error: error.localizedDescription)
                                   
                }
            }
        }
    
    
    
    
    class func storesByGeo(targetlat:Double, targetlng:Double, delegate:ConnDelegate, hideEmpty:Bool = false){
                
            debugPrint("lat:\(targetlat) lng:\(targetlng) range:\(Constants.rangeRadius)")
            
            Alamofire.request(Router.storesByGeo(lat: targetlat, lng:targetlng, m:Constants.rangeRadius))
                       .responseJSON { response in
                           
        
                       switch response.result {
                       case .success:
                        
                            var tmpStores : [Store] = []
                            
                            
                           if let data = response.result.value as? [String: Any] {
                               
                               let json = JSON(data)
                               
        //                           debugPrint("===getMainPackList===")
                                   debugPrint(json)

                               if let stores = json["stores"].array {

                                if stores.count == 0 {
                                    
                                }
                                
                                
                                    for store in stores{

                                    
                                        let code = store["code"].easyString
                                        let name = store["name"].easyString
                                        let addr = store["addr"].easyString
                                        
                                        let type = store["type"].easyString
                                        let remain_stat = store["remain_stat"].easyString
                                        
                                        let stock_at = store["stock_at"].easyString
                                        let created_at = store["created_at"].easyString
                                        
                                        let lat = store["lat"].float ?? 0.0
                                        let lng = store["lng"].float ?? 0.0
                                        
                                        
                                        let maskStore = Store(name: name, code: code, addr: addr, lat: lat, lng: lng, type: type, remain_stat: remain_stat, stock_at: stock_at, created_at: created_at)
        //                                        self.items.append(filterPack)
                                        
                                       if hideEmpty && remain_stat == "empty"{
                                                                        
                                       }else{
                                        tmpStores.append(maskStore)
                                        }
                                        
                                        
                                    }
                                
                                
                                
                                
                               
                                }
                            
                            
                           }
                           
                            delegate.succ(stores: tmpStores)
                           
                        break
                                           
                                       
                       case .failure(let error):
                                           
                        print("error : \(error)")
                        delegate.failed(error: error.localizedDescription)
                                       
                    
                       
                    }
                
            }
            
    }
    
}
