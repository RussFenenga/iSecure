//
//  FirebaseReference.swift
//  iSecure
//
//  Created by Russ Fenenga on 4/22/16.
//  Copyright © 2016 com.TeamWon. All rights reserved.

import Firebase

class FirebaseConnection {
    static let BASE_REF = Firebase(url: "https://isecurity.firebaseio.com")
    static let SENSORS_REF = Firebase(url: "https://isecurity.firebaseio.com/sensors")
    static let TEMP_REF = Firebase(url: "https://isecurity.firebaseio.com/sensors/tempature")
}
