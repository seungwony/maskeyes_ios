//
//  DateHelper.swift
//  maskeyes
//
//  Created by SEUNGWON YANG on 2020/03/13.
//  Copyright © 2020 co.giftree. All rights reserved.
//

import Foundation
class DateHelper {
    
    class func todayWeekDay() -> String{
        
         let dayDay:[String] = ["일요일", "월요일", "화요일", "수요일", "목요일", "금요일", "토요일" ]


       let today = Date()
        let idx = (today.weekday() ?? 1) - 1
        return dayDay[idx]
        
    }
  
    class func todayTarget() -> String{
        
         let dayDay:[String] = ["주간 미구매자", "출생연도 끝자리 1,6", "출생연도 끝자리 2,7", "출생연도 끝자리 3,8", "출생연도 끝자리 4,9", "출생연도 끝자리 5,0", "주간 미구매자" ]
        
        
        let today = Date()
        
        let idx = (today.weekday() ?? 1) - 1
        return dayDay[idx]
    }
    
    
   


  
}
extension Date {
    func weekday() -> Int? {
        return Calendar.current.dateComponents([.weekday], from: self).weekday
    }
}
extension Calendar {

    /// Return the weekSymbol index for the first week end day
    var firstWeekendDay: Int {
        let firstWeekDay = self.firstWeekday
        return (firstWeekDay - 2) >= 0 ? firstWeekDay - 2 : firstWeekDay - 2 + 7
    }

    /// Return the weekSymbol index for the second week end day
    var secondWeekendDay: Int {
        let firstWeekDay = self.firstWeekday
        return (firstWeekDay - 1) >= 0 ? firstWeekDay - 1 : firstWeekDay - 1 + 7
    }

}
