//
//  RGBDetailViewController.swift
//  iSecure
//
//  Created by Russ Fenenga on 4/23/16.
//  Copyright © 2016 com.TeamWon. All rights reserved.
//

import UIKit


class RGBDetailViewController: UIViewController {
    @IBOutlet weak var redSlider: UISlider!
    @IBOutlet weak var greenSlider: UISlider!
    @IBOutlet weak var blueSlider: UISlider!
    let prefs = NSUserDefaults.standardUserDefaults()
    
    override func viewWillAppear(animated: Bool) {
        if let redColor = prefs.objectForKey("redSlider"){
            if let greenColor = prefs.objectForKey("greenSlider"){
                if let blueColor = prefs.objectForKey("blueSlider"){
                    redSlider.value = redColor as! Float
                    greenSlider.value = greenColor as! Float
                    blueSlider.value = blueColor as! Float
                    changeColors()
                }
            }
        }else{
            changeColors()
            super.viewWillAppear(animated)
        }
    }
    @IBAction func redSliderChanged(sender: AnyObject) {
        changeColors()
    }
    @IBAction func greenSliderChanged(sender: AnyObject) {
        changeColors()
    }
    @IBAction func blueSliderChanged(sender: AnyObject) {
        changeColors()
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        prefs.setValue(redSlider.value, forKey: "redSlider")
        prefs.setValue(greenSlider.value, forKey: "greenSlider")
        prefs.setValue(blueSlider.value, forKey: "blueSlider")
    }
    
    func changeColors(){
        let red = CGFloat(redSlider.value)
        let blue = CGFloat(blueSlider.value)
        let green = CGFloat(greenSlider.value)
        
        let color = UIColor(
            red: red/255.0,
            green: green/255.0,
            blue: blue/255.0,
            alpha: 1.0)
        
        self.view.backgroundColor = color
    }
    @IBAction func updateTapped(sender: AnyObject) {
        let red = CGFloat(redSlider.value)
        let blue = CGFloat(blueSlider.value)
        let green = CGFloat(greenSlider.value)
        let dictionary: [String:CGFloat] = [
            "red" : red,
            "green" : green,
            "blue" : blue
        ]
        let ref = FirebaseConnection.RGB_REF.childByAutoId()
        ref.setValue(dictionary)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "RGB Led Values";
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
