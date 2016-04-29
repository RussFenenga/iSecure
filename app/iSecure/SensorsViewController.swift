//
//  SecondViewController.swift
//  iSecure
//
//  Created by Russ Fenenga on 4/22/16.
//  Copyright © 2016 com.TeamWon. All rights reserved.
//

import UIKit

class SensorsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var sensorsTableView: UITableView!
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.sensorsTableView.delegate=self
        self.sensorsTableView.dataSource=self
        self.sensorsTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    override func viewDidLoad() {
        self.navigationItem.title = "Sensors";
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = self.sensorsTableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Tempature"
            break
        case 1:
            cell.textLabel?.text = "Door System"
            break
        case 2:
            cell.textLabel?.text = "Light Intensity"
            break
        case 3:
            cell.textLabel?.text = "Lights"
            break
        case 4:
            cell.textLabel?.text = "Motion Sensor"
            break
        case 5:
            cell.textLabel?.text = "Humidity"
        default:
            break
        }
        
        
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //we are going to want to transition to a view that gives a nice view of the data for whatever thing was clicked.
        switch indexPath.row {
        case 0:
            self.performSegueWithIdentifier("didSelectTemp", sender: UITableViewCell())
            break
        case 1:
            self.performSegueWithIdentifier("didSelectDoor", sender: UITableViewCell())
            break
        case 2:
            self.performSegueWithIdentifier("didSelectLight", sender: UITableViewCell())
            break
        case 3:
            self.performSegueWithIdentifier("didSelectRGB", sender: UITableViewCell())
            break
        case 4:
            self.performSegueWithIdentifier("didSelectMotion", sender: UITableViewCell())
        case 5:
            self.performSegueWithIdentifier("didSelectHumidity", sender: UITableViewCell())
            break
        default:
            break
        }
        self.sensorsTableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if segue.identifier == "didSelectRow" {
//            let nextViewController = segue.destinationViewController as? SensorDetailViewController
//            if let indexPath = self.sensorsTableView.indexPathForSelectedRow {
//                let selectedSurfSpot = surfSpotData[indexPath.row]
//                nextViewController!.surfSpot = selectedSurfSpot as? SurfSpot
//            }
//        }
    }
}

