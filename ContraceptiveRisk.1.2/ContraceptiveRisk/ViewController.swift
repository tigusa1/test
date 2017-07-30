//
//  ViewController.swift
//  ContraceptiveRisk
//
//  Created by Tak Igusa on 7/25/17.
//  Copyright © 2017 JHU. All rights reserved.
//

import UIKit
import Charts

class ViewController: UIViewController, ChartViewControllerDelegate {
    var getExcelData: GetExcelData!
    var methodNames = Array<String>()                   // needed for extension
    var riskData = Array<Array<Double>>()
    var isObese: Bool!
    var showObeseButtonMessage = true
    let labels = ["MI","CVA","VTE","PID","Ectopic"]

    // delegate
    weak var axisFormatDelegate: IAxisValueFormatter?

    // user-entered data
    @IBOutlet weak var age: UITextField!
    @IBOutlet weak var weight: UITextField!
    @IBOutlet weak var height: UITextField!
    
    // risk factors
    @IBOutlet weak var Hypertension: UIButton!
    @IBOutlet weak var Smoking: UIButton!
    @IBOutlet weak var Obese: UIButton!
    
    // desired output
    @IBOutlet weak var Sterilization: UISwitch!
    @IBOutlet weak var Pill1: UISwitch!
    @IBOutlet weak var Pill2: UISwitch!
    @IBOutlet weak var IUD1: UISwitch!
    @IBOutlet weak var IUD2: UISwitch!
    @IBOutlet weak var Injection: UISwitch!
    @IBOutlet weak var Implant: UISwitch!
    @IBOutlet weak var Condom: UISwitch!
    @IBOutlet weak var Withdrawal: UISwitch!
    @IBOutlet weak var NoMethod: UISwitch!
    
    // outcome
    @IBOutlet weak var outcome: UISegmentedControl!
    
    // chart view
    @IBOutlet weak var barChartView: BarChartView!

    // enter button to accept text and retract keyboard
    @IBAction func enterText() {
        print("enter button pressed")
        if age.isEditing { age.resignFirstResponder() }
        else if weight.isEditing { weight.resignFirstResponder() }
        else if height.isEditing { height.resignFirstResponder() }
        showResults(view: barChartView)
    }

    // reset button
    @IBAction func reset() {
        Sterilization.setOn(true, animated: true)
        Pill1.setOn(true, animated: true)
        Pill2.setOn(true, animated: true)
        IUD1.setOn(true, animated: true)
        IUD2.setOn(true, animated: true)
        Injection.setOn(true, animated: true)
        Implant.setOn(true, animated: true)
        Condom.setOn(true, animated: true)
        Withdrawal.setOn(true, animated: true)
        NoMethod.setOn(true, animated: true)
        Hypertension.isSelected = false
        Smoking.isSelected = false
        Obese.isSelected = false
    }

    // select outcome
    @IBAction func selectOutcome(_ sender: UISegmentedControl) {
        print(outcome.selectedSegmentIndex)
        showResults(view: barChartView)
    }

    @IBAction func pushHypertension () {
        print("Hypertension button pressed")
        Hypertension.isSelected = !Hypertension.isSelected
        showResults(view: barChartView)
    }
    
    @IBAction func pushSmoking () {
        print("Smoking button pressed")
        Smoking.isSelected = !Smoking.isSelected
        showResults(view: barChartView)
    }
    
    @IBAction func pushObese () {
        print("Obese button pressed")
        
        let alertController = UIAlertController(title: "Obese button", message: "This button will override the height and weight information.", preferredStyle: .alert)
        
        let actionOverride = UIAlertAction(title: "Override", style: .default) { (action:UIAlertAction) in
            self.Obese.isSelected = !self.Obese.isSelected
            self.isObese = self.Obese.isSelected
            self.showResults(view: self.barChartView)
            self.showObeseButtonMessage = false
        }
        
        let actionDont = UIAlertAction(title: "Don't override", style: .default) { (action:UIAlertAction) in
        }
        
        alertController.addAction(actionOverride)
        alertController.addAction(actionDont)
        
        if showObeseButtonMessage {
            self.present(alertController, animated: true, completion:nil)
        } else {
            Obese.isSelected = !Obese.isSelected
            isObese = Obese.isSelected
            showResults(view: barChartView)
        }
    }
    
    @IBAction func updateHeightAge () {
        print("Height or Age updated")
        let bmi = Double(weight.text!)! / pow(Double(height.text!)! / 100.0, 2)
        if bmi < 30.0 {
            Obese.isSelected = false
            isObese = false
        } else {
            Obese.isSelected = true
            isObese = true
        }
        showResults(view: barChartView)
    }
    
    // initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // data and chart initialization
        getExcelData = GetExcelData()
        axisFormatDelegate = self as IAxisValueFormatter
        barChartView.delegate = self as? ChartViewDelegate
        updateHeightAge()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gotoEnlargeView" {
            let controller = segue.destination as! ChartViewController
            controller.viewController = self
            controller.delegate = self
        } else if segue.identifier == "gotoMultipleView" {
            let controller = segue.destination as! TableViewController
            controller.viewController = self
        }
    }
    
    func returnOutcomeIndex(_ controller: ChartViewController, outcomeIndex: Int) {
        outcome.selectedSegmentIndex = outcomeIndex
        showResults(view: barChartView)
        controller.navigationController?.popViewController(animated: true)
    }
    
    func showResults(view: BarChartView) {
        var methodIndeces = Array<Int>()

        methodIndeces = getMethods()
        riskData = getRiskData(indeces: methodIndeces)
        methodNames = getExcelData.getMethodNames(indeces: methodIndeces)
        setChart(index: outcome.selectedSegmentIndex, view: view)
    }
    
    func getMethods() -> Array<Int> {
        let methodsOn = [ Sterilization.isOn, Pill1.isOn, Pill2.isOn, IUD1.isOn, IUD2.isOn, Injection.isOn, Implant.isOn, Condom.isOn, Withdrawal.isOn, NoMethod.isOn ]
        var methodIndex = Array<Int>()
        // only include methods that are switched on
        for i in 0..<10 {
            if methodsOn[i] {
                methodIndex.append(Int(i))
            }
        }
        return methodIndex
    }
    
    func getRiskData(indeces: [Int]) -> Array<Array<Double>> {
        var ageCategory = Int(floor((Double(age.text!)!-15.0)/5.0))
        var stringRowOffset = 2
        ageCategory = min(7,max(0,ageCategory))
        stringRowOffset += ageCategory

        if Smoking.isSelected           {stringRowOffset += 21}
        else if Hypertension.isSelected {stringRowOffset += 14}
        else if isObese                 {stringRowOffset += 7 }

        var riskOutcomeDatum = Array<Array<Double>>()
        var riskDatum = Array<Double>()
        var datum = Double()
        var stringColumnOffsetOutcome: Int
        for j in 0..<5 {
            stringColumnOffsetOutcome = 3 + j * 10
            riskDatum.removeAll()
            for i in indeces {
                datum = getExcelData.getDatum(
                    dataRowIndex: stringRowOffset,
                    dataColumnIndex: i+stringColumnOffsetOutcome)
                riskDatum.append(datum)
            }
            riskOutcomeDatum.append(riskDatum)
        }
        return riskOutcomeDatum
    }
    
    func setChart(index: Int, view: BarChartView) {
        var dataEntries = [BarChartDataEntry]()
        let colorLow    = UIColor(red: 130/255, green: 126/255, blue: 34/255, alpha: 1)
        let colorMedium = UIColor(red: 230/255, green: 126/255, blue: 34/255, alpha: 1)
        let colorHigh   = UIColor(red: 230/255, green: 026/255, blue: 34/255, alpha: 1)
        let values = riskData[index]
        
        for i in 0..<methodNames.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y:values[i])
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "")
        let chartData = BarChartData(dataSet: chartDataSet)
        view.data = chartData
        let xaxis = view.xAxis
        xaxis.valueFormatter = axisFormatDelegate
        xaxis.labelPosition = .bottom
        // for centered labels, need to set the label count to one more than displayed
        xaxis.centerAxisLabelsEnabled = true
        xaxis.setLabelCount(1 + methodNames.count, force: true)
        
        chartDataSet.colors = [NSUIColor]()
        var colorRisk = UIColor()
        for i in 0..<methodNames.count{
            if        values[i]<100 {colorRisk = colorLow
            } else if values[i]<200 {colorRisk = colorMedium
            } else                  {colorRisk = colorHigh
            }
            chartDataSet.colors.append(colorRisk)
        }
        
        view.backgroundColor = UIColor(
            red: 250/255, green: 250/255, blue: 250/255, alpha: 1)
        
        if view.tag == 0 {
            view.animate(xAxisDuration: 0.5, yAxisDuration: 0.5)
        }
        view.chartDescription?.text = ""
        view.legend.enabled = false
        //        let ll = ChartLimitLine(limit: 10.0, label: "Target")
        //        barChartView.rightAxis.addLimitLine(ll)
    }
}

extension ViewController: IAxisValueFormatter {
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        var index = Int(value + 0.5)
        if index >= Int(((axis?.axisMaximum)! + 0.5)) {
            index = Int(((axis?.axisMaximum)! + 0.5)) - 1
        }
        return methodNames[index]
    }
}

