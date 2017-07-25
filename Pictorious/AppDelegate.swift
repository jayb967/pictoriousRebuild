//
//  AppDelegate.swift
//  Pictorious
//
//  Created by Rio Balderas on 7/15/17.
//  Copyright © 2017 Jay Balderas. All rights reserved.
//

import UIKit
import UserNotifications

import Firebase
import FirebaseAuthUI

import FirebaseInstanceID
import FirebaseMessaging

import GoogleMobileAds
import SDWebImage

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        if #available(iOS 10.0, *) {
            let authOptions : UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_,_ in })
            
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            // For iOS 10 data message (sent via FCM)
            Messaging.messaging().delegate = self
            
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
            application.registerForRemoteNotifications()
        }
        
        application.registerForRemoteNotifications()
        
        FirebaseApp.configure()
        SDWebImageManager.shared().imageDownloader?.maxConcurrentDownloads = kMaxConcurrentImageDownloads
        Database.database().isPersistenceEnabled = true
        
        //TODO: Currently signs in user as anonymous.
        Auth.auth().signInAnonymously() { (user, error) in
//            let isAnonymous = user!.isAnonymous  // true
//            let uid = user!.uid
            
            if let currentUser = Auth.auth().currentUser {
                UserProfile.collection.child(user!.uid).queryOrderedByKey().observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    // if snapshot is empty, means user is not created yet
                    if snapshot.childrenCount == 0 {
                        
                        // update displayname and photo
                        let userdata = UserProfile(user!.uid)
                        userdata.name = currentUser.displayName ?? kDefaultUsername
                        userdata.photo = currentUser.photoURL?.absoluteString ?? kDefaultProfilePhoto
                        userdata.saveData()
                    }
                })
                //will make side scrollview the default start page (Only if user is "logged in")
                self.window = UIWindow(frame: UIScreen.main.bounds)
                self.window!.rootViewController = MySwipeVC()
                self.window!.makeKeyAndVisible()
            }
            print("there was an error\(String(describing: error?.localizedDescription))")
        }
        
        
        
        
        if kAdMobEnabled {
            GADMobileAds.configure(withApplicationID: kAdMobApplicationID)
        }
        
        // Add observer for InstanceID token refresh callback.
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.tokenRefreshNotification),
                                               name: NSNotification.Name.InstanceIDTokenRefresh,
                                               object: nil)
        
        
        
        return true
    }
    
    @available(iOS 9.0, *)
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
        let sourceApplication = options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String
        return FIRAuthUI.default()?.handleOpen(url, sourceApplication: sourceApplication) ?? false
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return FIRAuthUI.default()?.handleOpen(url, sourceApplication: sourceApplication ?? "") ?? false
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        Messaging.messaging().disconnect()
        print("Disconnected from FCM.")
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        connectToFcm()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // MARK: Push Notifications
    
//    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
//                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
//        // If you are receiving a notification message while your app is in the background,
//        // this callback will not be fired till the user taps on the notification launching the application.
//        // TODO: Handle data of notification
//        
//        // Print message ID.
//        print("Message ID: \(userInfo["gcm.message_id"]!)")
//        
//        // Print full message.
//        print("%@", userInfo)
//    }
    
    func tokenRefreshNotification(_ notification: Notification) {
        if let refreshedToken = InstanceID.instanceID().token() {
            print("InstanceID token: \(refreshedToken)")
        }
        
        // Connect to FCM since connection may have failed when attempted before having a token.
        connectToFcm()
    }
    
    func connectToFcm() {
        Messaging.messaging().connect { (error) in
            if (error != nil) {
                print("Unable to connect with FCM. \(error)")
            } else {
                print("Connected to FCM.")
            }
        }
    }
}

@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        // Print message ID.
        print("Message ID: \(userInfo["gcm.message_id"]!)")
        
        // Print full message.
        print("%@", userInfo)
    }
}

extension AppDelegate : MessagingDelegate {
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        print("Current token:\(fcmToken)")
    }
    
    // Receive data message on iOS 10 devices.
    func application(received remoteMessage: MessagingRemoteMessage) {
        print("%@", remoteMessage.appData)
    }
}
