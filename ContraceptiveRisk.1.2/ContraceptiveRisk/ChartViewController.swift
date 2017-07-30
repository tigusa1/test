//
//  ChartViewController.swift
//  ContraceptiveRisk
//
//  Created by Tak Igusa on 7/26/17.
//  Copyright © 2017 JHU. All rights reserved.
//

import UIKit
import Charts

protocol ChartViewControllerDelegate: class {
    func returnOutcomeIndex(_ controller: ChartViewController, outcomeIndex: Int)
}

class ChartViewController: UIViewController {
    var outcomeIndex = 0
    
    // chart view
    weak var viewController: ViewController?
    
    weak var delegate: ChartViewControllerDelegate?
    
    @IBOutlet weak var chartView: BarChartView!

    // outcome
    @IBOutlet weak var outcome: UISegmentedControl!
    
    // select outcome
    @IBAction func selectOutcome(_ sender: UISegmentedControl) {
        print(outcome.selectedSegmentIndex)
        outcomeIndex = outcome.selectedSegmentIndex
        viewController?.outcome.selectedSegmentIndex = outcomeIndex
        viewController?.setChart(index: outcomeIndex, view: chartView)
    }
    
    // return
    @IBAction func returnToViewController(_ sender: UIBarButtonItem) {
        delegate?.returnOutcomeIndex(self, outcomeIndex: outcomeIndex)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        outcomeIndex = (viewController?.outcome.selectedSegmentIndex)!
        outcome.setEnabled(true, forSegmentAt: outcomeIndex)
        outcome.selectedSegmentIndex = outcomeIndex
        viewController?.setChart(index: outcomeIndex, view: chartView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
