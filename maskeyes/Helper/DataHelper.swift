//
//  DataUtil.swift
//  maskeyes
//
//  Created by SEUNGWON YANG on 2020/03/13.
//  Copyright © 2020 co.giftree. All rights reserved.
//

import Foundation
import UIKit
class DataHelper {
    
    class func convertReadableRemainStat(stat:String) -> String{
        if(stat == "plenty"){
            return "100+"
        }else if(stat == "some"){
            return "30+"
        }else if(stat == "few"){
            return "1~30"
        }else if(stat == "empty"){
            return "품절"
        }
        
        return "자료없음"
    }
    
    
    class func convertColorRemainStat(stat:String) -> UIColor{
        if(stat == "plenty"){
            return ColorPalette.stat_plenty
          }else if(stat == "some"){
            return ColorPalette.stat_some
          }else if(stat == "few"){
            return ColorPalette.stat_few
          }else if(stat == "empty"){
            return ColorPalette.stat_empty
          }
        return ColorPalette.stat_unknown
    }
    
    
    class func saveSmartWidgetOption(option:Int){
           let userDefaults = UserDefaults(suiteName: Constants.share_group)
           userDefaults?.set(option, forKey: "smartwidget_option")
    }
    
    class func saveRangeRadius(range:Int){
           let userDefaults = UserDefaults(suiteName: Constants.share_group)
           userDefaults?.set(range, forKey: "range")
    }
    class func rangeStr(range:Int) -> String{
        if range == 500 {
            return "500m"
        }else if range == 1000 {
            return "1km"
        }else if range == 2000 {
            return "2km"
        }else if range == 3000 {
            return "3km"
        }else if range == 5000 {
            return "5km"
        }
        
        return "3km"
    }
    
    class func smartWidgetOrderStr(option:Int) -> String{
          if option == 0 {
              return "재고 있음(자료없음 제외) > 가까운 순"
          }else if option == 1 {
              return "재고 있음(자료없음 포함) > 가까운 순"
          }else if option == 2 {
              return "가까운 순"
          }
          
          return "재고 있음(자료없음 제외) > 가까운 순"
      }
    
    
    class func saveEnableSmartWidget(enable:Bool){
           let userDefaults = UserDefaults(suiteName: Constants.share_group)
           userDefaults?.set(enable, forKey: "enableSW")
       }
    
    class func convertColorRemainStatLight(stat:String) -> UIColor{
           if(stat == "plenty"){
            return UIColor.green
             }else if(stat == "some"){
               return ColorPalette.stat_some
             }else if(stat == "few"){
               return ColorPalette.stat_few
             }else if(stat == "empty"){
               return ColorPalette.stat_empty
             }
           return ColorPalette.stat_unknown
       }
    
    
    class func typeIcon(type:String) -> UIImage{
        let t : Int = Int( type) ?? 1
        
        if t == 1 {
            return UIImage(named:"type01")!
        } else if t == 2 {
            return UIImage(named:"type02")!
        } else if t == 3 {
            return UIImage(named:"type03")!
        }
        return UIImage(named:"type_unknown")!
    }
    
    
    class func markerImg(type:String, stat:String) -> String{
        let t : Int = Int( type) ?? 1
        
         if t == 1 {
             
            if(stat == "plenty"){
               return "marker_type01_plenty"
            }else if(stat == "some"){
              return "marker_type01_some"
            }else if(stat == "few"){
              return "marker_type01_few"
            }else if(stat == "empty"){
              return "marker_type01_empty"
            }else{
              return "marker_type01_unknown"
            }
         } else if t == 2 {
             
             if(stat == "plenty"){
                return "marker_type02_plenty"
             }else if(stat == "some"){
               return "marker_type02_some"
             }else if(stat == "few"){
               return "marker_type02_few"
             }else if(stat == "empty"){
               return "marker_type02_empty"
             }else{
               return "marker_type02_unknown"
             }
         } else if t == 3 {
             if(stat == "plenty"){
                return "marker_type03_plenty"
             }else if(stat == "some"){
               return "marker_type03_some"
             }else if(stat == "few"){
               return "marker_type03_few"
             }else if(stat == "empty"){
               return "marker_type03_empty"
             }else{
               return "marker_type03_unknown"
             }
         }
        
        return "marker_type01_unknown"
    }
}
