//
//  TodayViewController.swift
//  widget
//
//  Created by SEUNGWON YANG on 2020/03/11.
//  Copyright © 2020 co.giftree. All rights reserved.
//

import UIKit
import NotificationCenter
import CoreLocation
class TodayViewController: UIViewController, NCWidgetProviding {
    @IBOutlet weak var type_icon01: UIImageView!
    @IBOutlet weak var type_icon02: UIImageView!
    @IBOutlet weak var type_icon03: UIImageView!
    @IBOutlet weak var name01: UILabel!
    
    @IBOutlet weak var name03: UILabel!
    @IBOutlet weak var name02: UILabel!
    
    @IBOutlet weak var remain_stat01: UILabel!
    
    @IBOutlet weak var remain_stat02: UILabel!
    @IBOutlet weak var remain_stat03: UILabel!
    
    var currLat : Double?
    var currLng : Double?
    
    @IBOutlet weak var targetLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    
        resetUI()

        
    }
        

    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
//        var enable_txt = "no"
//        if let groupUserDefaults = UserDefaults(suiteName: Constants.share_group){
//        let enable = groupUserDefaults.bool(forKey: "enableSW")
//            enable_txt = enable ? "yes" : "noo"
//        }
//
        
       
        let todayTarget = DateHelper.todayWeekDay() + " (\(DateHelper.todayTarget()) 대상) 스마트 위젯"
        
        targetLabel.text = todayTarget
        LocationHelperForWidget.shared.locationManagerDelegate = self
        LocationHelperForWidget.shared.startUpdatingLocation()
        
        completionHandler(NCUpdateResult.newData)
    }
    
    @IBAction func onClickLaunchApp(_ sender: Any) {
        let url: NSURL = NSURL(string: "maskeyes://")!
        self.extensionContext?.open(url as URL, completionHandler: nil)
    }
}


extension TodayViewController : ConnDelegate {
    
    func succ(stores : [Store] ){
        
        // distance 정렬
        var sorted =  stores.sorted(by: { $0.distance ?? 0 < $1.distance ?? 0 })
        
        if Constants.smartWidgetOrder == 0 {
           sorted = stores.sorted(by: {
            let com1 = $0.remain_stat == "empty" || $0.remain_stat == "" || $0.remain_stat == "break" ? 1 : -1
            let com2 = $1.remain_stat == "empty" || $1.remain_stat == "" || $1.remain_stat == "break" ? 1 : -1
           
            return com1 < com2
            
           })
            
            
            
        }else if Constants.smartWidgetOrder == 1 {
                  sorted = stores.sorted(by: {
                   let com1 = $0.remain_stat == "empty" ? 1 : -1
                   let com2 = $1.remain_stat == "empty" ? 1 : -1
                  
                   return com1 < com2
                   
                  })
                   
        }
        
        
        
//        for store in stores {
//
//            let name = store.name
//            let remain_stat = store.remain_stat
//            let lat = store.lat
//            let lng = store.lng
//            let type = store.type
//
//
//            debugPrint("name :\(name) remain :\(remain_stat)")
//
//
//
//
//        }
        
        
        
        // empty 제외
        resetUI()
        
        if sorted.count > 2 {
            
            let first = sorted[0]
            let second = sorted[1]
            let third = sorted[2]
            
            type_icon01.image = DataHelper.typeIcon(type:first.type)
            name01.text = first.name
            remain_stat01.text = DataHelper.convertReadableRemainStat(stat: first.remain_stat)
            remain_stat01.textColor = DataHelper.convertColorRemainStatLight(stat: first.remain_stat)
            
            type_icon02.image = DataHelper.typeIcon(type:second.type)
            name02.text = second.name
            remain_stat02.text = DataHelper.convertReadableRemainStat(stat: second.remain_stat)
            remain_stat02.textColor = DataHelper.convertColorRemainStatLight(stat: second.remain_stat)
            
            type_icon03.image = DataHelper.typeIcon(type:third.type)
            name03.text = third.name
            remain_stat03.text = DataHelper.convertReadableRemainStat(stat: third.remain_stat)
            remain_stat03.textColor = DataHelper.convertColorRemainStatLight(stat: third.remain_stat)
            
        }else if sorted.count == 2 {
            let first = sorted[0]
            let second = sorted[1]
            
            
            type_icon01.image = DataHelper.typeIcon(type:first.type)
            name01.text = first.name
            remain_stat01.text = DataHelper.convertReadableRemainStat(stat: first.remain_stat)
            remain_stat01.textColor = DataHelper.convertColorRemainStatLight(stat: first.remain_stat)
            
            type_icon02.image = DataHelper.typeIcon(type:second.type)
            name02.text = second.name
            remain_stat02.text = DataHelper.convertReadableRemainStat(stat: second.remain_stat)
            remain_stat02.textColor = DataHelper.convertColorRemainStatLight(stat: second.remain_stat)
                    
                
                    
        }else if sorted.count == 1 {
            let first = sorted[0]
                    
            type_icon01.image = DataHelper.typeIcon(type:first.type)
            name01.text = first.name
            remain_stat01.text = DataHelper.convertReadableRemainStat(stat: first.remain_stat)
            remain_stat01.textColor = DataHelper.convertColorRemainStatLight(stat: first.remain_stat)
               
                    
        }
        
        
        
    }
    
    func failed(error:String){
        resetUI()
    }
    
    func resetUI(){
        type_icon01.image = DataHelper.typeIcon(type:"")
        name01.text = "없음"
        remain_stat01.text = ""
        
        type_icon02.image = DataHelper.typeIcon(type:"")
        name02.text = "없음"
        remain_stat02.text = ""
        
        type_icon03.image = DataHelper.typeIcon(type:"")
        name03.text = "없음"
        remain_stat03.text = ""
    }
    
    
}
extension TodayViewController : LocationManagerForWidgetDelegate {
    func getLocation(location: CLLocation) {
//      currentLocation = location.coordinate
    
        let lat = Double(location.coordinate.latitude)
        let lng = Double(location.coordinate.longitude)
        
        currLat = lat
        currLng = lng
        
        ApiHelper.storesByGeo(targetlat: lat, targetlng: lng, currLat:lat, currLng:lng, delegate: self)

        LocationHelperForWidget.shared.stopUpdatingLocation()
    }
    
    
    
}
