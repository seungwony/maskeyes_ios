//
//  ViewController.swift
//  maskeyes
//
//  Created by SEUNGWON YANG on 2020/03/11.
//  Copyright © 2020 co.giftree. All rights reserved.
//

import UIKit
import NMapsMap
import Alamofire
import SwiftyJSON
import JGProgressHUD
import MessageUI
import PopupDialog
import GoogleMobileAds
import FirebaseCrashlytics
protocol MoveCameraDelegate {

    func moveToPosition(x:Double, y:Double)
    
   
}

class ViewController: UIViewController {

//    @IBOutlet weak var adView: UIView!
    @IBOutlet weak var versionLabel: UILabel!
    
//    var bannerView: GADBannerView!
    @IBOutlet weak var bannerView: GADBannerView!
    
    @IBOutlet weak var switchHideEmpty: UISwitch!
    @IBOutlet weak var targetBirthLabel: UILabel!
    @IBOutlet weak var smartSwitch: UISwitch!
    
    @IBOutlet weak var priorityLabel: UILabel!
    @IBOutlet weak var rangeLabel: UILabel!
    @IBOutlet weak var naverMapView: NMFNaverMapView!
    @IBOutlet weak var mapCameraView: UIView!
    //    let naverMapView:NMFNaverMapView?
//    var naverMap : NMFMapView?
    
    
    
    var currentLocation : CLLocationCoordinate2D?
    
    var maskStores : [Store] = []
    
    
    var markers: [NMFMarker] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Ask for Authorisation from the User.
//         bannerView = GADBannerView(adSize: kGADAdSizeBanner)
//        bannerView.center = CGPoint(x: adView.frame.width / 2, y: 0)

//        adView.addSubview(bannerView)
//        bannerView.frame = adView.bounds
//        bannerView.centerXAnchor.constraint(equalTo: adView.centerXAnchor).isActive = true
        
        bannerView.adSize = kGADAdSizeBanner
//        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
      bannerView.adUnitID = "ca-app-pub-6930055600634279/3680837243"
      bannerView.rootViewController = self
        bannerView.delegate = self
        
          bannerView.load(GADRequest())
        
     
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            self.versionLabel.text = "Version : \(version)"
        }
        
        targetBirthLabel.text = DateHelper.todayWeekDay() + " (\(DateHelper.todayTarget()) 대상)"
        
        naverMapView.showCompass = true
        naverMapView.showZoomControls = true

        naverMapView.showLocationButton = false
              
        
//        mapCameraView.addSubview(naverMap!)
        
      
        
        
        
        LocationHelper.shared.locationManagerDelegate = self
        LocationHelper.shared.startUpdatingLocation()
        
        
        
    
        
        if Constants.initialUser {
            
            
//        DataHelper.saveEnableSmartWidget(enable: true)

           DataHelper.saveSmartWidgetOption(option:0)
            DataHelper.saveRangeRadius(range: 3000)
            
                 
            
            rangeLabel.text = DataHelper.rangeStr(range: Constants.rangeRadius)
            
            priorityLabel.text = DataHelper.smartWidgetOrderStr(option:Constants.smartWidgetOrder)
//            smartSwitch.isOn = Constants.enableSmartWidget
                 
            
            self.showNotice()
        }
        
        
        

    }
    
//    func addMarker(){
//        let marker = NMFMarker(position: NMGLatLng(lat: 37.5666102, lng: 126.9783881))
//        marker.touchHandler = { (overlay) in
//            print("마커 클릭됨")
//            return true
//        }
//        marker.mapView = naverMapView.mapView
//    }
    
    func moveCamera(lat:Double, lng:Double){
       let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: lat, lng: lng))
       cameraUpdate.reason = 3
       cameraUpdate.animation = .fly
       cameraUpdate.animationDuration = 2
        naverMapView.mapView.minZoomLevel = 10
        naverMapView.mapView.maxZoomLevel = 18
        naverMapView.mapView.zoomLevel = 15
       naverMapView.mapView.moveCamera(cameraUpdate, completion: { (isCancelled) in
           if isCancelled {
               print("카메라 이동 취소")
           } else {
               print("카메라 이동 성공")
           }
        
        
      
        
        
        if let location = self.currentLocation {
            let cLat = Double(location.latitude)
            let cLng = Double(location.longitude)
            
            ApiHelper.storesByGeo(targetlat: lat, targetlng: lng, currLat: cLat, currLng: cLng,   delegate: self, hideEmpty: self.switchHideEmpty.isOn)
        }else{
            
            ApiHelper.storesByGeo(targetlat: lat, targetlng: lng,   delegate: self, hideEmpty: self.switchHideEmpty.isOn)
        }
//            self.storesByGeo(lat: lat, lng: lng)
        

        

        
       })
    }
    
    
    func adjustDistance(){
        
        if let loc = currentLocation {
            
            
            for i in 0 ..< maskStores.count {
                var store = maskStores[i]
                let lat = store.lat
                let lng = store.lng
                
                let currLat = Double(loc.latitude)
                let currLng = Double(loc.longitude)
                
                
                store.distance = GPSHelper.distance(lat: Double(lat), lng: Double(lng), clat: currLat, clng: currLat)
                                                 
                                                 
                store.disStr = GPSHelper.distanceWithKilometer(lat: Double(lat), lng: Double(lng), clat: currLat, clng: currLng)
            }
          
        }

    }
    
//    func moveTest(){
//       let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: 37.5666102, lng: 126.9783881))
//       cameraUpdate.reason = 3
//       cameraUpdate.animation = .fly
//       cameraUpdate.animationDuration = 2
//
//       naverMapView.mapView.moveCamera(cameraUpdate, completion: { (isCancelled) in
//           if isCancelled {
//               print("카메라 이동 취소")
//           } else {
//               print("카메라 이동 성공")
//           }
//
//
//
//          self.addMarker()
//
//       })
//    }

    @IBAction func onChangeHideEmpty(_ sender: Any) {
        findStores()
        
    }
    @IBAction func onChangeSmartSwitch(_ sender: UISwitch) {
        
        
        DataHelper.saveEnableSmartWidget(enable:sender.isOn)
        
        debugPrint("smart wdiget enable : \(Constants.enableSmartWidget)")

        
    }
    
    @IBAction func onClickSearchAddress(_ sender: Any) {
        let searchVC = SearchAddressViewController.create()
        searchVC.delegate = self
        navigationController?.pushViewController(searchVC, animated: true)
    }
    
    @IBAction func onClickFindStoreCurrentCamera(_ sender: Any) {
        
       
        
        findStores()
        
    }
    
    
    func findStores(){
            let lat = naverMapView.mapView.cameraPosition.target.lat
               let lng = naverMapView.mapView.cameraPosition.target.lng
               
               
               if let currPos = currentLocation {
                   let cLat = Double(currPos.latitude)
                   let cLng = Double(currPos.longitude)
                ApiHelper.storesByGeo(targetlat: lat, targetlng: lng, currLat:cLat, currLng:cLng, delegate: self, hideEmpty: self.switchHideEmpty.isOn)
               }else{
                   ApiHelper.storesByGeo(targetlat: lat, targetlng: lng, delegate: self, hideEmpty: self.switchHideEmpty.isOn)
               }
               
    }
    
    @IBAction func onClickRangeSetting(_ sender: Any) {
        showRangeAlert()
    }
    
    @IBAction func onClickPriorityWidget(_ sender: Any) {
        showPriorityAlert()
    }
    
    
    @IBAction func onClickCurrentPosition(_ sender: Any) {
        LocationHelper.shared.startUpdatingLocation()
    }
    
    
    @IBAction func onClickHelp(_ sender: Any) {
        showGuidePopup()
    }
    @IBAction func onClickMaskPolicy(_ sender: Any) {
        
//       showNotice()
        
    }
    
    func showNotice(){
        let webViewController = WebViewWithButtonViewController.create()
        
        webViewController.url = "http://giftree.co/maskeyes_intro.html"
        webViewController.modalPresentationStyle = .fullScreen
        present(webViewController, animated: true, completion: nil)
    }
    
    @IBAction func onClickLIst(_ sender: Any) {
//        adjustDistance()
        let storeListViewController = StoreListViewController.create()
        storeListViewController.setStoreItems(stores:maskStores)
        storeListViewController.delegate = self
        navigationController?.pushViewController(storeListViewController, animated: true)
    }
    
    @IBAction func onClickContact(_ sender: Any) {
        sendEmail()
    }
    fileprivate func showMarkerPopup(store:Store){
            let popupVC = StoreInfoViewController(nibName: "StoreInfoViewController", bundle: nil)
          // Create the dialog
          let popup = PopupDialog(viewController: popupVC,
                                  buttonAlignment: .vertical,
                                  transitionStyle: .fadeIn,
                                  tapGestureDismissal: true,
                                  panGestureDismissal: false)
          
       
        // Create second button
         let kakaomapButton = DefaultButton(title: "카카오 지도") {
             
            
            let url = "https://map.kakao.com/link/map/\(store.name),\(store.lat),\(store.lng)"
            
            self.openBrowser(url)
             
         }
        // Create second button
         let googlemapButton = DefaultButton(title: "구글 지도") {
             let url = "https://www.google.com/maps/place/\(store.lat)+\(store.lng)/@\(store.lat),\(store.lng),z20"
            self.openBrowser(url)
             
         }
          // Create second button
          let confirmButton = DefaultButton(title: "확인") {
              
              
          }
          
          // Add buttons to dialog
          popup.addButtons([kakaomapButton, googlemapButton, confirmButton])
        
        
          
        if let viewC = popup.viewController as? StoreInfoViewController {
            viewC.nameLabel.text = store.name
                   
               if let disStr = store.disStr{
                   viewC.distanceLabel.text = "거리 : \(disStr)"
               }else{
                   viewC.distanceLabel.isHidden = true
               }
               
               viewC.typeIcon.image = DataHelper.typeIcon(type: store.type)
            viewC.addressLabel.text =  store.addr
               viewC.remainLabel.text = "마스크 재고 : \(DataHelper.convertReadableRemainStat(stat: store.remain_stat))"
               viewC.remainLabel.textColor = DataHelper.convertColorRemainStat(stat: store.remain_stat)
            
            let stock_at = store.stock_at == "" ? "입고시간 없음" : "입고시간 : \(store.stock_at)"
               viewC.stockatLabel.text = stock_at
                   
        }
          
       

          
          // Present dialog
          present(popup, animated: true, completion: nil)
      }
    
    func openBrowser(_ urlStr:String){
        
        
        guard let url = URL(string: urlStr) else { return }
        UIApplication.shared.open(url)
    }
    
    fileprivate func showGuidePopup(){
          
          let popupVC = GuideViewController(nibName: "GuideViewController", bundle: nil)
          
          // Create the dialog
          let popup = PopupDialog(viewController: popupVC,
                                  buttonAlignment: .vertical,
                                  transitionStyle: .bounceDown,
                                  tapGestureDismissal: true,
                                  panGestureDismissal: false)
          
       
          // Create second button
          let confirmButton = DefaultButton(title: "확인") {
              
              
          }
          
          // Add buttons to dialog
          popup.addButtons([confirmButton])
        
        
          
          
          
          // Present dialog
          present(popup, animated: true, completion: nil)
      }
    

    func clearAllMarkers(){
//        naverMap.

        if markers.count > 0 {
            for marker in self.markers{
                  marker.mapView = nil
                  marker.touchHandler = nil
              }
              
              markers.removeAll()
        }
        
      
        
    }
    
    func refreshAllMarker(){
        
        clearAllMarkers()
     
        
        
        for store in self.maskStores{
            
            let lat = Double(store.lat)
            let lng = Double(store.lng)
            
//            print("marker - name : \(store.name) lat : \(lat) lng : \(lng)")
            
           
            
            let marker = NMFMarker(position: NMGLatLng(lat: lat, lng: lng))
            
            
            marker.captionText = store.name
            
            marker.subCaptionText = DataHelper.convertReadableRemainStat(stat: store.remain_stat)
            
            marker.width = 55
            marker.height = 55
            
            marker.subCaptionColor = DataHelper.convertColorRemainStat(stat: store.remain_stat)
            
            marker.iconImage = NMFOverlayImage(name: DataHelper.markerImg(type: store.type, stat: store.remain_stat))
            
               marker.touchHandler = { (overlay) in
                self.showMarkerPopup(store:store)
                   
                   return true
               }
            marker.mapView = self.naverMapView.mapView
            
            self.markers.append(marker)
        
            
        }
    }
    
    func showPriorityAlert() {
            let alertController = UIAlertController(title: "위젯 우선순위", message: "위젯에 우선적으로 정렬할 판매처를 설정합니다.", preferredStyle: UIAlertController.Style.alert)
           
        let case1 = UIAlertAction(title: "재고 있음(자료없음 제외) > 가까운 순", style: .default, handler: {(cAlertAction) in
            
            DataHelper.saveSmartWidgetOption(option:0)
                       
                       
              
                       
            self.priorityLabel.text = DataHelper.smartWidgetOrderStr(option:Constants.smartWidgetOrder)
                
            })
        
        let case2 = UIAlertAction(title: "재고 있음(자료없음 포함) > 가까운 순", style: .default, handler: {(cAlertAction) in
                      
                           DataHelper.saveSmartWidgetOption(option:1)
                                      
                                      
                             
                                      
                           self.priorityLabel.text = DataHelper.smartWidgetOrderStr(option:Constants.smartWidgetOrder)
                  })
              
        let case3 = UIAlertAction(title: "가까운 순", style: .default, handler: {(cAlertAction) in
            
                 DataHelper.saveSmartWidgetOption(option:2)
                            
                            
                   
                            
                 self.priorityLabel.text = DataHelper.smartWidgetOrderStr(option:Constants.smartWidgetOrder)
        })
    
        
            let cancelAction = UIAlertAction(title: "cancel", style: UIAlertAction.Style.cancel)
        alertController.addAction(case1)
        alertController.addAction(case2)
        alertController.addAction(case3)
        
            alertController.addAction(cancelAction)
            
        present(alertController, animated: true, completion: nil)
        
        }
    
    func showRangeAlert() {
            let alertController = UIAlertController(title: "반경 범위", message: "판매처 탐색 범위를 설정합니다.", preferredStyle: UIAlertController.Style.alert)
           
        let c500mAction = UIAlertAction(title: "500m", style: .default, handler: {(cAlertAction) in
                
                       
            DataHelper.saveRangeRadius(range: 500)
                       
            self.rangeLabel.text = DataHelper.rangeStr(range: Constants.rangeRadius)
            
            
            self.findStores()
                       
                       
            })
        
        let c1kmAction = UIAlertAction(title: "1km", style: .default, handler: {(cAlertAction) in
            DataHelper.saveRangeRadius(range: 1000)
                       
            self.rangeLabel.text = DataHelper.rangeStr(range: Constants.rangeRadius)
                  self.findStores()
                  })
              
        let c2kmAction = UIAlertAction(title: "2km", style: .default, handler: {(cAlertAction) in
            DataHelper.saveRangeRadius(range: 2000)
                       
            self.rangeLabel.text = DataHelper.rangeStr(range: Constants.rangeRadius)
            self.findStores()
        })
        let c3kmAction = UIAlertAction(title: "3km", style: .default, handler: {(cAlertAction) in
                 DataHelper.saveRangeRadius(range: 3000)
                                      
                           self.rangeLabel.text = DataHelper.rangeStr(range: Constants.rangeRadius)
            self.findStores()
             })
        let c5kmAction = UIAlertAction(title: "5km", style: .default, handler: {(cAlertAction) in
                      DataHelper.saveRangeRadius(range: 5000)
                                           
                                self.rangeLabel.text = DataHelper.rangeStr(range: Constants.rangeRadius)
                self.findStores()
                  })
        
            let cancelAction = UIAlertAction(title: "cancel", style: UIAlertAction.Style.cancel)
        alertController.addAction(c500mAction)
        alertController.addAction(c1kmAction)
        alertController.addAction(c2kmAction)
        alertController.addAction(c3kmAction)
        alertController.addAction(c5kmAction)
        
            alertController.addAction(cancelAction)
            
            
        present(alertController, animated: true, completion: nil)
    }
}

extension ViewController : LocationManagerDelegate {
    func getLocation(location: CLLocation) {
          currentLocation = location.coordinate
        
        let lat = Double(location.coordinate.latitude)
        let lng = Double(location.coordinate.longitude)
        debugPrint("currentLocation x:\(lat) y:\(lng)")
        self.moveCamera(lat: lat, lng: lng)
        
        LocationHelper.shared.stopUpdatingLocation()
    }
    
    
    
         
    
}


extension ViewController : ConnDelegate {
      
        func succ(stores : [Store] ){
            
           
            
            self.maskStores.removeAll()
            
            for store in stores {
                self.maskStores.append(store)
            }
            
            debugPrint("stores : \(self.maskStores.count)")
            
            self.refreshAllMarker()
            
//            self.adjustDistance()
            
        }
        
        func failed(error:String){
            //예외처리
            
            let errorAlertController = UIAlertController(title: NSLocalizedString("Error", comment: "Error"), message: "서버에 문제가 생겨 데이터를 못 받고 있습니다.", preferredStyle: .alert)
           errorAlertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "OK"), style: .default, handler: nil))
           self.present(errorAlertController, animated: true, completion: nil)
        }
        
}

extension ViewController : MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
           controller.dismiss(animated: true)
       }
    func sendEmail() {
           //guard let user = getUserInfo() else { return }
           
           if MFMailComposeViewController.canSendMail() {
               let mail = MFMailComposeViewController()
               mail.mailComposeDelegate = self
               mail.setToRecipients(["master@giftree.co"])
               mail.setSubject("[마스크아이즈] 문의사항")
               mail.setMessageBody("", isHTML: false)
               
               present(mail, animated: true)
           } else {
               // show failure alert
           }
       }
}

extension ViewController : MoveCameraDelegate {
    func moveToPosition(x:Double, y:Double){
        
        debugPrint("x:\(x) y:\(y)")
        
                   
       DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.6) {
            self.moveCamera(lat: x, lng: y)
       }
        
    }
}

extension ViewController : GADBannerViewDelegate{
    /// Tells the delegate an ad request loaded an ad.
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
               // adView.isHidden = false
      print("adViewDidReceiveAd")
    }

    /// Tells the delegate an ad request failed.
    func adView(_ bannerView: GADBannerView,
        didFailToReceiveAdWithError error: GADRequestError) {
        
        bannerView.isHidden = true
        print("adView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }

    /// Tells the delegate that a full-screen view will be presented in response
    /// to the user clicking on an ad.
    func adViewWillPresentScreen(_ bannerView: GADBannerView) {
      print("adViewWillPresentScreen")
    }

    /// Tells the delegate that the full-screen view will be dismissed.
    func adViewWillDismissScreen(_ bannerView: GADBannerView) {
      print("adViewWillDismissScreen")
    }

    /// Tells the delegate that the full-screen view has been dismissed.
    func adViewDidDismissScreen(_ bannerView: GADBannerView) {
      print("adViewDidDismissScreen")
    }

    /// Tells the delegate that a user click will open another app (such as
    /// the App Store), backgrounding the current app.
    func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
      print("adViewWillLeaveApplication")
    }
}
