//
//  DoorDetailViewController.swift
//  iSecure
//
//  Created by Russ Fenenga on 4/23/16.
//  Copyright © 2016 com.TeamWon. All rights reserved.
//

import UIKit


class DoorDetailViewController: UIViewController {
    
    @IBOutlet weak var statusLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Door Status";
        FirebaseConnection.DOOR_REF.observeEventType(.ChildAdded, withBlock: { snapshot in
            let status = snapshot.value.objectForKey("test") as! String
            if(status == "open"){
                self.statusLabel.text = "Open"
            } else if (status == "closed"){
                self.statusLabel.text = "Closed"
            }
                print(status)
            }, withCancelBlock: { error in
                print(error.description)
        })
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        let handle = FirebaseConnection.DOOR_REF.observeEventType(.ChildAdded, withBlock: { snapshot in
            //print("Snapshot value: \(snapshot.value)")
        })
        FirebaseConnection.DOOR_REF.removeObserverWithHandle(handle)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}