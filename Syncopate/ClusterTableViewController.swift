//
//  ClusterTableViewController.swift
//  Syncopate
//
//  Created by Gary Chang on 9/4/15.
//  Copyright (c) 2015 Gary Chang. All rights reserved.
//

import UIKit

class ClusterTableViewController: UITableViewController {

    // MARK: Properties
    var clusters = [ClusterState]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        clusters = AppManager.sharedInstance.getClusters()
        
        // Initialize background and separator color
        self.tableView.backgroundColor = SyncopateStyle.menuBackgroundColor
        self.tableView.separatorColor = SyncopateStyle.menuSeparatorColor
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        self.tableView.separatorInset = UIEdgeInsetsZero
        
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

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clusters.count
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("You selected cell number: \(indexPath.row)!")
        // AppManager.sharedInstance.setSelectedCluster(clusters[indexPath.row].name)
        // performSegueWithIdentifier("showChannelTableView", sender: self)
        AppManager.sharedInstance.updateClusterDetail(clusters[indexPath.row].id, callback: showCallback)
    }
    
    func showCallback(success: Bool) {
        if success {
            // NOTE: prepareSeque MUST be in the main thread, otherwise does not work in callback!!!
            dispatch_async(dispatch_get_main_queue()) {
                self.performSegueWithIdentifier("showChannelTableView", sender: self)
            }
        } else {
            // TODO: Logout
            println("updateClusterDetail failed")
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "ClusterTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! ClusterTableViewCell
    
        let cluster = clusters[indexPath.row]
        
        cell.nameLabel.text = cluster.name
        cell.nameLabel.textColor = SyncopateStyle.menuTextColor
        cell.contentView.backgroundColor = SyncopateStyle.menuBackgroundColor
        
        // Selection colors
        var bgColorView = UIView()
        bgColorView.backgroundColor = SyncopateStyle.menuSelectedColor
        cell.selectedBackgroundView = bgColorView
        
        // Get rid of separators
        cell.layoutMargins = UIEdgeInsetsZero
        cell.preservesSuperviewLayoutMargins = false
        
        return cell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    /*
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if segue.identifier == "showChannelTableView" {
            if let navController = segue.destinationViewController as? UINavigationController {
                if var vc = navController.topViewController as? ChannelTableViewController {
                    if let indexPath = self.tableView.indexPathForSelectedRow() {
                        // vc.navTitle = clusters[indexPath.row].name
                        AppManager.sharedInstance.setSelectedCluster(clusters[indexPath.row].name)
                    }
                }
            }
        }
    }
    */
}
