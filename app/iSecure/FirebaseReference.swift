//
//  FirebaseReference.swift
//  iSecure
//
//  Created by Russ Fenenga on 4/22/16.
//  Copyright © 2016 com.TeamWon. All rights reserved.

import Firebase

class FirebaseConnection {
    static let BASE_REF = Firebase(url: "https://isecurity.firebaseio.com")
    static let SENSORS_REF = Firebase(url: "https://isecurity.firebaseio.com/Sensors")
    static let TEMP_REF = Firebase(url: "https://isecurity.firebaseio.com/Sensors/Temp/Data")
    static let DOOR_REF = Firebase(url: "https://isecurity.firebaseio.com/Sensors/Door/Data")
    static let LIGHT_REF = Firebase(url: "https://isecurity.firebaseio.com/Sensors/DayLight/Data")
    static let RGB_REF = Firebase(url: "https://isecurity.firebaseio.com/Sensors/RGB/Data")
    static let DEVICE_REF = Firebase(url: "https://isecurity.firebaseio.com/Devices")
    static let MOTION_REF = Firebase(url: "https://isecurity.firebaseio.com/Sensors/Motion/Data")
    static let BUZZER_REF = Firebase(url: "https://isecurity.firebaseio.com/Sensors/buzzer")
    static let BEACON_REF = Firebase(url: "https://isecurity.firebaseio.com/Sensors/beacons/data")
}
