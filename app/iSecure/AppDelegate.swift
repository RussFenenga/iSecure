//
//  AppDelegate.swift
//  iSecure
//
//  Created by Russ Fenenga on 4/22/16.
//  Copyright © 2016 com.TeamWon. All rights reserved.
//

import UIKit
import WatchConnectivity

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, WCSessionDelegate, ESTBeaconManagerDelegate{

    var window: UIWindow?
    private static let regionIdentifier = "iSecure"
    
    let beaconRegion = CLBeaconRegion(
        proximityUUID: NSUUID(UUIDString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D")!,
        major: 312, identifier: regionIdentifier);
    
    // Used in error check for beacon scanning
    var rangingTimestamp : Double = 0;
    var countRangingOutRoom = 0;
    
    // Setup beaconManager object
    let beaconManager = ESTBeaconManager()
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        registerForPushNotifications(application)

        UIApplication.sharedApplication().applicationIconBadgeNumber = 0
        if WCSession.isSupported() {
            let session = WCSession.defaultSession()
            session.delegate = self // conforms to WCSessionDelegate
            session.activateSession()
        }
        var applicationDict = [String:String]()
        FirebaseConnection.DOOR_REF.observeEventType(.ChildAdded, withBlock: { snapshot in
            let status = snapshot.value.objectForKey("test") as! String
            if(status == "open"){
                applicationDict["test"] = "open"
                do {
                        try WCSession.defaultSession().updateApplicationContext(applicationDict)
                } catch {
                    // Handle errors here
                }
            } else if (status == "closed"){
                applicationDict["test"] = "closed"
                do {
                        try WCSession.defaultSession().updateApplicationContext(applicationDict)
                } catch {
                    // Handle errors here
                }
            }
                }, withCancelBlock: { error in
                    print(error.description)
            })
        
        
            // Set the beacon manager's delegate
            self.beaconManager.delegate = self
        
            // Request authorization from the user
            self.beaconManager.requestAlwaysAuthorization()
        
            // More regions to specify when entering in the room
        
            // For the building 8 break room
            self.beaconManager.startMonitoringForRegion(beaconRegion)
        
            self.beaconManager.startRangingBeaconsInRegion(beaconRegion)
            self.beaconManager.requestStateForRegion(beaconRegion)
        return true
    }
    func beaconManager(manager: AnyObject, didEnterRegion region: CLBeaconRegion) {
        // Clear previous notfications
        UIApplication.sharedApplication().applicationIconBadgeNumber = 0
        UIApplication.sharedApplication().cancelAllLocalNotifications()
        
        let notification = UILocalNotification()
        
        print("Entered region \(region.identifier)")
        
        if(region.identifier == AppDelegate.regionIdentifier){
            
            notification.alertBody = "You Entered \(region.identifier)"
            let dictionary: [String:Bool] = [
                "inRoom":true]
            let ref = FirebaseConnection.BEACON_REF.childByAutoId()
            ref.setValue(dictionary)
            UIApplication.sharedApplication().presentLocalNotificationNow(notification)
            let entered: [String:Int] = [
                "red" : 255,
                "green" : 255,
                "blue" : 150
            ]
            FirebaseConnection.RGB_REF.setValue(entered)
            self.beaconManager.startRangingBeaconsInRegion(beaconRegion)
        }
    }
    
    func beaconManager(manager: AnyObject, didExitRegion region: CLBeaconRegion) {
        // Clear previous notfications
        UIApplication.sharedApplication().applicationIconBadgeNumber = 0
        UIApplication.sharedApplication().cancelAllLocalNotifications()
        let notification = UILocalNotification()
        
        // update firebase
        // NOTE: will still trigger in DB that the person has LEFT the area, so they don't get stuck "on screen"
        // This will not notify them if leaving area, but will still push to database about exiting.
        print("Exited region \(region.identifier)")
        
        if(region.identifier == AppDelegate.regionIdentifier){
            print("You Left!")
            
            // :: TODO :: if signed in - push to service that we're out of the room!
            
            notification.alertBody = "You Exited \(region.identifier)"
            let dictionary: [String:Bool] = [
                "inRoom":false]
            let ref = FirebaseConnection.BEACON_REF.childByAutoId()
            ref.setValue(dictionary)
            
            UIApplication.sharedApplication().presentLocalNotificationNow(notification)
            let exited: [String:Int] = [
                "red" : 0,
                "green" : 0,
                "blue" : 0
            ]
            FirebaseConnection.RGB_REF.setValue(exited)
            self.beaconManager.startRangingBeaconsInRegion(beaconRegion)
        }
    }
    
    func beaconManager(manager: AnyObject, didRangeBeacons beacons: [CLBeacon],
                       inRegion region: CLBeaconRegion) {
        var activeTracking = true
        if let active = NSUserDefaults.standardUserDefaults().objectForKey("activeTracking") as! Bool! { activeTracking = active }
        else {activeTracking = true}
        if(activeTracking){
            if let nearestBeacon = beacons.first {
                // print("nearestBeacons")
                // print(nearestBeacon)
                let distance = nearestBeacon.proximity
                
                var distanceReading = 0
                switch distance {
                case .Unknown:
                    distanceReading = 0
                    
                case .Far:
                    distanceReading = 1
                    
                case .Near:
                    distanceReading = 1
                    
                case .Immediate:
                    distanceReading = 1
                }
                if(rangingTimestamp == 0){
                    rangingTimestamp = NSDate.timeIntervalSinceReferenceDate()
                }
                // If last rangingTimestamp is older than 30 seconds, reset count
                if((NSDate.timeIntervalSinceReferenceDate() - rangingTimestamp) >= 30000){
                    countRangingOutRoom = 0;
                }
                
                if(distanceReading == 1){
                    //     print("Ranging in Room\n");
                    
                } else {
                    if(distanceReading == 0){
                        // If it ranges more than three times out of room -- This obviously needs some more thought
                        // Really, we might not even need to do this in a confined space like a conference room.
                        if(countRangingOutRoom >= 3){
                            //           print("Ranging out Room\n");
                        }
                    }
                }
                
                //print(distanceReading)
            }
        }
    }
    
    func session(session: WCSession, didReceiveApplicationContext applicationContext: [String : AnyObject]) {
        print("\(applicationContext["test"] as? Int)")
        FirebaseConnection.BUZZER_REF.setValue(applicationContext["test"] as? Int)
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
        if notificationSettings.types != .None {
            application.registerForRemoteNotifications()
        }
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
//        let tokenChars = UnsafePointer<CChar>(deviceToken.bytes)
//        var tokenString = ""
        print(deviceToken)
//        for i in 0..<deviceToken.length {
//            tokenString += String(format: "%02.2hhx", arguments: [tokenChars[i]])
//        }
//        FirebaseConnection.DEVICE_REF.setValue(deviceToken)
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        print("Failed to register:", error)
    }
    
    func registerForPushNotifications(application: UIApplication) {
        let notificationSettings = UIUserNotificationSettings(
            forTypes: [.Badge, .Sound, .Alert], categories: nil)
        application.registerUserNotificationSettings(notificationSettings)
    }

}

