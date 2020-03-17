//
//  LocationHelper.swift
//  maskeyes
//
//  Created by SEUNGWON YANG on 2020/03/12.
//  Copyright © 2020 co.giftree. All rights reserved.
//
import UIKit
import CoreLocation
import Foundation
@objc protocol LocationManagerDelegate {
    @objc optional func getLocation(location: CLLocation)
}

class LocationHelper: NSObject, CLLocationManagerDelegate {

    weak var locationManagerDelegate: LocationManagerDelegate?
    var isLocationfetched: Bool = false
    var lastKnownLocation: CLLocation? {
        get {
            let latitude = UserDefaults.standard.double(forKey: Constants.lastKnownLatitude)
            let longitude = UserDefaults.standard.double(forKey: Constants.lastKnownLongitude)

            if latitude.isZero || longitude.isZero {
                return nil
            }
            return CLLocation(latitude: latitude, longitude: longitude)
        }
        set {
            UserDefaults.standard.set(newValue?.coordinate.latitude ?? 0, forKey: Constants.lastKnownLatitude)
            UserDefaults.standard.set(newValue?.coordinate.longitude ?? 0, forKey: Constants.lastKnownLongitude)
            UserDefaults.standard.synchronize()
        }
    }

    struct SharedInstance {
        static let instance = LocationHelper()
    }

    class var shared: LocationHelper {
        return SharedInstance.instance
    }

    enum Request {
        case requestWhenInUseAuthorization
        case requestAlwaysAuthorization
        
    }

    var clLocationManager = CLLocationManager()

    func setAccuracy(clLocationAccuracy: CLLocationAccuracy) {
        clLocationManager.desiredAccuracy = clLocationAccuracy
    }

    var isLocationEnable: Bool = false {
        didSet {
            if !isLocationEnable {
                lastKnownLocation = nil
            }
        }
    }
    
    
    func startUpdatingLocation() {
        isLocationfetched = false
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined:
                clLocationManager.delegate = self
               
//                clLocationManager.requestAlwaysAuthorization()

                clLocationManager.requestWhenInUseAuthorization()
                clLocationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
                clLocationManager.startUpdatingLocation()
                isLocationEnable = true
            case .restricted, .denied:
                showLocationAccessAlert()
                isLocationEnable = false
            case .authorizedAlways, .authorizedWhenInUse:
                self.clLocationManager.delegate = self
                self.clLocationManager.startUpdatingLocation()
                isLocationEnable = true
            default:
                print("Invalid AuthorizationStatus")
            }
        } else {
            isLocationEnable = false
            showLocationAccessAlert()
        }
    }

    
    func showLocationAccessAlert() {
           let alertController = UIAlertController(title: "Location Permission Required", message: "Please enable location permissions in settings.", preferredStyle: UIAlertController.Style.alert)
           let okAction = UIAlertAction(title: "settings", style: .default, handler: {(cAlertAction) in
               UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
           })
           let cancelAction = UIAlertAction(title: "cancel", style: UIAlertAction.Style.cancel)
           alertController.addAction(cancelAction)
           alertController.addAction(okAction)
           let appdelegate = UIApplication.shared.delegate as? AppDelegate
           appdelegate?.window?.rootViewController?.present(alertController, animated: true, completion: nil)
       }

       func stopUpdatingLocation() {
           self.clLocationManager.stopUpdatingLocation()
       }

       func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
           if !isLocationfetched {
               isLocationfetched = true
               clLocationManager.startMonitoringSignificantLocationChanges()
//               NotificationCenter.default.post(name: NSNotification.Name.updateLocationNotification, object: nil)
           }
           let userLocation = locations[0] as CLLocation
           self.lastKnownLocation = userLocation
           if let delegate = self.locationManagerDelegate {
               delegate.getLocation!(location: userLocation)
           }
       }

       func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
           if (status == CLAuthorizationStatus.denied) {
               // The user denied authorization
               isLocationEnable = false
           } else if (status == CLAuthorizationStatus.authorizedWhenInUse) {
               // The user accepted authorization
               self.clLocationManager.delegate = self
               self.clLocationManager.startUpdatingLocation()
               isLocationEnable = true
           }
       }

       func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
           print("\n error description for location updation:- \(error.localizedDescription)")
       }
}
