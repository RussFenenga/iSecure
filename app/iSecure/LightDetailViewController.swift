//
//  LightDetailViewController.swift
//  iSecure
//
//  Created by Russ Fenenga on 4/23/16.
//  Copyright © 2016 com.TeamWon. All rights reserved.
//

import UIKit


class LightDetailViewController: UIViewController {
    @IBOutlet weak var intensityLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Light Intensity";
        
        FirebaseConnection.LIGHT_REF.observeEventType(.ChildAdded, withBlock: { snapshot in
            let status = snapshot.value.objectForKey("value") as! String
            print("LIGHT VALUE: \(status)")
            self.intensityLabel.text = status
            }, withCancelBlock: { error in
                print(error.description)
        })
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        let handle = FirebaseConnection.LIGHT_REF.observeEventType(.ChildAdded, withBlock: { snapshot in
            //print("Snapshot value: \(snapshot.value)")
        })
        FirebaseConnection.LIGHT_REF.removeObserverWithHandle(handle)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}