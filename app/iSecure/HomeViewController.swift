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

    override func viewDidLoad() {
        super.viewDidLoad()
        FirebaseConnection.TEMP_REF.observeEventType(.ChildAdded, withBlock: { snapshot in
            let stringValue = snapshot.value.objectForKey("value") as! String
            if(stringValue != "nan"){
                let value = (Float(stringValue)!)
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}