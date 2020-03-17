//
//  AppDelegate.swift
//  maskeyes
//
//  Created by SEUNGWON YANG on 2020/03/11.
//  Copyright © 2020 co.giftree. All rights reserved.
//

import UIKit
//import NMapsMap
import Firebase
import GoogleMobileAds

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
//    var orientationLock = UIInterfaceOrientationMask.all
    let gcmMessageIDKey = "gcm.message_id"
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
//        NMFAuthManager.shared().clientId = "YOUR_CLIENT_ID_HERE"
        
         let defaults = UserDefaults.standard
        defaults.register(defaults: ["initialUser" : true])
        defaults.synchronize()

        
        
        
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        
        if #available(iOS 10.0, *) {
          // For iOS 10 display notification (sent via APNS)
          UNUserNotificationCenter.current().delegate = self

          let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
          UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: {_, _ in })
        } else {
          let settings: UIUserNotificationSettings =
          UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
          application.registerUserNotificationSettings(settings)
        }

        application.registerForRemoteNotifications()
        
        FirebaseApp.configure()
        Messaging.messaging().shouldEstablishDirectChannel = true
        // [START set_messaging_delegate]
        Messaging.messaging().delegate = self
        
        
        // Define identifier
        let notificationName = Notification.Name("NotificationIdentifier")
        
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(methodOfReceivedNotification), name: notificationName, object: nil)
        
        // Post notification
        NotificationCenter.default.post(name: notificationName, object: nil)
        return true
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
          // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
          Messaging.messaging().shouldEstablishDirectChannel = true
      }
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

        @objc dynamic private func methodOfReceivedNotification(notification: NSNotification){
            //Take Action on Notification
            //        print("\(notification.userInfo?.count ?? 0)")
            //        notification.userInfo.
            
            let token = Messaging.messaging().fcmToken
            print("FCM token: \(token ?? "")")
            
            Messaging.messaging().shouldEstablishDirectChannel = true
        }
        
        // [START receive_message]
        func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
            // If you are receiving a notification message while your app is in the background,
            // this callback will not be fired till the user taps on the notification launching the application.
            // TODO: Handle data of notification
            // With swizzling disabled you must let Messaging know about the message, for Analytics
            // Messaging.messaging().appDidReceiveMessage(userInfo)
            // Print message ID.
            
            debugPrint("application didReceiveRemoteNotification")
            
            if let messageID = userInfo[gcmMessageIDKey] {
                print("Message ID: \(messageID)")
            }
            
            // Print full message.
            print(userInfo)
            
            switch UIApplication.shared.applicationState {
            case .active:
                //app is currently active, can update badges count here
                
                
                break
            case .inactive:
                //app is transitioning from background to foreground (user taps notification), do what you need when user taps here
                
                
                break
            case .background:
                //app is in background, if content-available key of your notification is set to 1, poll to your backend to retrieve data and update your interface here
                
                guard let rootViewController = self.window?.rootViewController as? UITabBarController else {
                    return
                }
                // select second tab
                //            rootViewController.selectedIndex = 1
                
                guard let navigationController = rootViewController.selectedViewController as? UINavigationController else {
                    return
                }
                
                break
            default:
                break
            }
            
            
        }
        
        func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                         fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
            
            
            Messaging.messaging().appDidReceiveMessage(userInfo)
            debugPrint("application didReceiveRemoteNotification fetchCompletionHandler")
            
            switch application.applicationState {
                
                
            case .inactive:
                print("Inactive")
                //Show the view with the content of the push
                completionHandler(.newData)
                
            case .background:
                print("Background")
                //Refresh the local model
                completionHandler(.newData)
                
            case .active:
                print("Active")
                //Show an in-app banner
                //
                completionHandler(.newData)
                //            completionHandler(UIBackgroundFetchResult.newData)
            }
            
            // If you are receiving a notification message while your app is in the background,
            // this callback will not be fired till the user taps on the notification launching the application.
            // TODO: Handle data of notification
            // With swizzling disabled you must let Messaging know about the message, for Analytics
            // Messaging.messaging().appDidReceiveMessage(userInfo)
            // Print message ID.
            if let messageID = userInfo[gcmMessageIDKey] {
                print("Message ID: \(messageID)")
            }
            
            // Print full message.
            print(userInfo)
            
            //        if userInfo["title"] != nil{
            //
            //            let notification = UILocalNotification()
            //            notification.alertBody = userInfo["subject"] as? String // text that will be displayed in the notification
            //            notification.alertAction = "open" // text that is displayed after "slide to..." on the lock screen - defaults to "slide to view"
            //            notification.fireDate = NSDate.init() as Date // todo item due date (when notification will be fired). immediately here
            //            notification.soundName = UILocalNotificationDefaultSoundName // play default sound
            //            UIApplication.sharedApplication().scheduleLocalNotification(notification)
            //        }
            
            
            
            //        completionHandler(UIBackgroundFetchResult.newData)
        }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        //        print(deviceTokenString)
        print( "노티피케이션 등록을 성공함, 디바이스 토큰 : \(deviceTokenString)" )
        //        Messaging.messaging().apnsToken = deviceToken
        #if DEBUG
        Messaging.messaging().setAPNSToken(deviceToken, type: .sandbox)
        #else
        Messaging.messaging().setAPNSToken(deviceToken, type: .prod)
        #endif
        
        
    }
       func connectToFcm() {
           
           Messaging.messaging().shouldEstablishDirectChannel = true
           
       }
}



// [START ios_10_message_handling]
@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    
    
    
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        debugPrint("UNUserNotificationCenter willPresent withCompletionHandler")
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        print("Handle push from foreground")
        // Print full message.
//        print(userInfo)
        
        
        
        
        Messaging.messaging().appDidReceiveMessage(userInfo)
        // Change this to your preferred presentation option
        
        
        completionHandler([.alert, .sound ])
        //        completionHandler([.alert])
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        print("Handle push from background or closed")
        print(response.notification.request.content.userInfo)
        debugPrint("UNUserNotificationCenter didReceive withCompletionHandler")
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        print("response.actionIdentifier : \(response.actionIdentifier)")
        
        
        if let aps = userInfo["aps"] as? [String: AnyObject] {
            let category = aps["category"] as? String
            
           
            
//            if category == AppConstants.sharedInstance.sendChatMessage
//                || category == AppConstants.sharedInstance.logHomet
//                || category == AppConstants.sharedInstance.logMission
//                || category == AppConstants.sharedInstance.logDiet
//                || category == AppConstants.sharedInstance.logBody{
//                 NotificationCenter.default.post(name: NSNotification.Name(rawValue: AppConstants.sharedInstance.sendChatMessage), object: nil, userInfo: userInfo)
//            }
        }
        
        switch response.actionIdentifier {
            
            
        case UNNotificationDefaultActionIdentifier:
            //            self.present()
            
            
            
            
            completionHandler()
            
        default:
            break;
        }
        
        
        // Print full message.
        print(userInfo)
        
    }
    
    
    
}
extension AppDelegate : MessagingDelegate {
    // [START refresh_token]
    
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
    }
    // [END refresh_token]
    // [START ios_10_data_message]
    // Receive data messages on iOS 10+ directly from FCM (bypassing APNs) when the app is in the foreground.
    // To enable direct data messages, you can set Messaging.messaging().shouldEstablishDirectChannel to true.
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print("Received data message: \(remoteMessage.appData)")
        //        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "test"), object: nil)
        
//        if let custom = remoteMessage.appData["customContent"] {
//            debugPrint("custom : \(custom)")
//            if let dict = JsonHelper.convertToDictionary(text:custom as! String) {
//                let what = dict["what"] as? String ?? ""
//                debugPrint("what : \(what)")
//
//
//
//
//            }
//
//        }
        
        //        remoteMessage.appData["gcm.notification.customContent"].
        
        Messaging.messaging().appDidReceiveMessage(remoteMessage.appData)
        
        
     
        
//        if let aps = remoteMessage.appData["gcm.notification.customContent"] as? [String: AnyObject] {
//
//            // 2
//            //            NewsItem.makeNewsItem(aps)
//
//            debugPrint(aps)
//
//
//            let category = aps["category"] as? String
//            if category == AppConstants.sharedInstance.sendChatMessage {
//
//
//                AppConstants.sharedInstance.userDefaults.set(true, forKey: AppConstants.sharedInstance.sendChatMessage)
//            }
//        }
        
    }
    // [END ios_10_data_message]
    
    
    
    
}


func setBadgeCount(badgeCount:Int){
    
    let application = UIApplication.shared
    let center = UNUserNotificationCenter.current()
    center.requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in
        // Enable or disable features based on authorization.
    }
    application.registerForRemoteNotifications()
    application.applicationIconBadgeNumber = badgeCount
}
