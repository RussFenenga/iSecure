//
//  SensorDetailViewController.swift
//  iSecure
//
//  Created by Russ Fenenga on 4/23/16.
//  Copyright © 2016 com.TeamWon. All rights reserved.
//

import UIKit
import Charts

class SensorDetailViewController: UIViewController {
    @IBOutlet weak var lineChart: LineChartView!
    private var dataPoints = [Double]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Temperature Report"
        var scale = [Int]()
        // Do any additional setup after loading the view, typically from a nib.
        let count = 0
        FirebaseConnection.TEMP_REF.observeEventType(.ChildAdded, withBlock: { snapshot in
            let stringValue = snapshot.value.objectForKey("test") as! String
            if(stringValue != "nan"){
                let value = (Double(stringValue)!)
               // print ("VALUE: \(value)")
                self.dataPoints.append(value)
                scale.append(count+1)
                self.setChart(scale, values: self.dataPoints)
            }
            }, withCancelBlock: { error in
                print(error.description)
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        let handle = FirebaseConnection.TEMP_REF.observeEventType(.ChildAdded, withBlock: { snapshot in
            //print("Snapshot value: \(snapshot.value)")
        })
        FirebaseConnection.TEMP_REF.removeObserverWithHandle(handle)
    }
    
    func setChart(scaleOfTemps: [Int], values: [Double]) {
        lineChart.noDataText = "You need to provide data for the chart."
        var dataEntries: [ChartDataEntry] = []
        //print(scaleOfTemps.count)
        //print(values.count)
        for i in 0..<scaleOfTemps.count {
            let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        let lineChartDataSet = LineChartDataSet(yVals: dataEntries, label: "Temperature in Degrees Farenheit")
        lineChart.descriptionText = "Graph of the tempature probe"
        lineChartDataSet.circleRadius = 4.0
        lineChartDataSet.drawCirclesEnabled = true
        let lineChartData = LineChartData(xVals: scaleOfTemps, dataSet: lineChartDataSet)
        lineChart.data = lineChartData
    }
}
