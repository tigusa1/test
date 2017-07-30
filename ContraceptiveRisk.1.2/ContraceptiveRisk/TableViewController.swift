//
//  TableViewController.swift
//  ContraceptiveRisk
//
//  Created by Tak Igusa on 7/27/17.
//  Copyright © 2017 JHU. All rights reserved.
//

import UIKit
import Charts

class TableViewController: UITableViewController {
    var images = Array<UIImage>()
    let labels = ["MI","CVA","VTE","PID","Ectopic"]
    
    weak var viewController: ViewController?

    @IBOutlet weak var cellView: BarChartView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewItem", for: indexPath)
        if images.count < 5 {
            cellView.noDataText = ""
            cellView.renderer?.viewPortHandler?.setChartDimens(
                width: ((cellView.renderer?.viewPortHandler?.chartWidth)! -  30),
                height: (cellView.renderer?.viewPortHandler?.chartHeight)!)
            for i in 0..<5 {
                viewController?.setChart(index: i, view: cellView)
                images.append(cellView.getChartImage(transparent: false)!)
            }
            cellView.clear()
        }
        
        // Configure the cell...
        configureLabel(for: cell, with: labels[indexPath.row])
        cell.imageView?.image = images[indexPath.row]

        return cell
    }
    

    func configureLabel(for cell: UITableViewCell, with label: String) {
        let cellLabel = cell.viewWithTag(1000) as! UILabel
        cellLabel.text = label
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
