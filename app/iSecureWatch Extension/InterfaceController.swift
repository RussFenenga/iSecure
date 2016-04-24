//
//  InterfaceController.swift
//  iSecureWatch Extension
//
//  Created by Russ Fenenga on 4/23/16.
//  Copyright © 2016 com.TeamWon. All rights reserved.
//

import WatchKit
import WatchConnectivity
import Foundation

class InterfaceController: WKInterfaceController,WCSessionDelegate {
    @IBOutlet var doorStatusLabel: WKInterfaceLabel!
    var state = 0

    @IBAction func AlarmButtonPressed() {
        var applicationDict = [String:Int]()
        if(state == 0){
            state = 1
            applicationDict["value"] = state
            do {
                try WCSession.defaultSession().updateApplicationContext(applicationDict)
            } catch {
                // Handle errors here
            }
        } else {
            state = 0
            applicationDict["value"] = state
            do {
                try WCSession.defaultSession().updateApplicationContext(applicationDict)
            } catch {
                // Handle errors here
            }
        }
    }
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        if (WCSession.isSupported()) {
            let session = WCSession.defaultSession()
            session.delegate = self
            session.activateSession()
            
        }
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    func session(session: WCSession, didReceiveApplicationContext applicationContext: [String : AnyObject]) {
        doorStatusLabel.setText(applicationContext["test"] as? String)
    }

}
