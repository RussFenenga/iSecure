//
//  HomeViewController.swift
//  iSecure
//
//  Created by Russ Fenenga on 4/23/16.
//  Copyright © 2016 com.TeamWon. All rights reserved.
//

import UIKit


class HomeViewController: UIViewController {

    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var alarmButton: UIButton!
    @IBOutlet weak var doorStatusLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
    FirebaseConnection.DOOR_REF.observeEventType(.ChildAdded, withBlock: { snapshot in
            let status = snapshot.value.objectForKey("test") as! String
            if(status == "open"){
                self.doorStatusLabel.text = "Open"
            } else if (status == "closed"){
                self.doorStatusLabel.text = "Closed"
            }
            print(status)
            }, withCancelBlock: { error in
                print(error.description)
        })
        
        FirebaseConnection.BUZZER_REF.observeEventType(.Value, withBlock: { snapshot in
            print(snapshot.value)
            if(snapshot.value as! Int == 1){
                self.alarmButton.titleLabel?.textColor = UIColor.redColor()
                self.alarmButton.titleLabel?.text = "Turn Off"
            } else {
                self.alarmButton.titleLabel?.textColor = UIColor.greenColor()
            }
            }, withCancelBlock: { error in
                print(error.description)
        })
        
        FirebaseConnection.TEMP_REF.observeEventType(.ChildAdded, withBlock: { snapshot in
           let stringValue = snapshot.value.objectForKey("value") as? String
            if(stringValue != "nan"){
                let value = (Float(stringValue!)!)
                print ("HomePageTemp: \(value)")
                self.temperatureLabel.text = "\(value)"
            }
            }, withCancelBlock: { error in
                print(error.description)
        })
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        let handle = FirebaseConnection.TEMP_REF.observeEventType(.ChildAdded, withBlock: { snapshot in
            //print("Snapshot value: \(snapshot.value)")
        })
        FirebaseConnection.TEMP_REF.removeObserverWithHandle(handle)
    }
    
    @IBAction func didPressAlarmButton(sender: AnyObject) {
        FirebaseConnection.BUZZER_REF.setValue(0)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}