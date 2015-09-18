//
//  SeriesTableViewController.swift
//  Syncopate
//
//  Created by Gary Chang on 9/3/15.
//  Copyright (c) 2015 Gary Chang. All rights reserved.
//

import UIKit

class ChannelTableViewController: UITableViewController {

    // MARK: Properties
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // self.tableView.dataSource = self

        // Initialize background and separator color
        self.tableView.backgroundColor = SyncopateStyle.mainBackgroundColor
        self.tableView.separatorColor = SyncopateStyle.mainSeparatorColor
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        self.tableView.separatorInset = UIEdgeInsetsZero
        
        // Initialize navigation bar
        self.navigationItem.title = AppManager.sharedInstance.getSelectedCluster()
        var navBar = self.navigationController?.navigationBar
        navBar?.barTintColor = SyncopateStyle.mainNavColor
        let titleProp: NSDictionary = [NSForegroundColorAttributeName: SyncopateStyle.mainTextColor]
        navBar?.titleTextAttributes = titleProp as [NSObject: AnyObject]
        navBar?.tintColor = SyncopateStyle.mainTextColor

        // Initialize navigation menu button
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        // Initialize refresh controller
        self.refreshControl?.addTarget(self, action: "handleRefresh:", forControlEvents: UIControlEvents.ValueChanged)
        AppManager.sharedInstance.onSocketCallback = {(success: Bool) -> Void in
            if success {
                dispatch_async(dispatch_get_main_queue()) {
                    // println("reloadData")
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    @IBAction func logoutAction(sender: UIBarButtonItem) {
        var logoutAlert = UIAlertController(title: "Logout", message: "Are you sure?", preferredStyle: UIAlertControllerStyle.Alert)
        
        logoutAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
            println("Handle Ok logic here")
            AppManager.sharedInstance.logout()
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.showLoginScreen(false)
        }))
        
        logoutAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction!) in
            // println("Handle Cancel Logic here")
            // Do nothing
        }))
        
        presentViewController(logoutAlert, animated: true, completion: nil)
    }
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        // Do some reloading of data and update the table view's data source
        // Fetch more objects from a web service, for example...
        
        // Simply adding an object to the data source for this example
        println("handleRefresh")
        AppManager.sharedInstance.refreshClusterDetail({(success: Bool, status: Int?) -> Void in
            if success {
                dispatch_async(dispatch_get_main_queue()) {
                    // NOTE: Wait for websocket message to call reloadData(), otherwise user will see
                    //       list with blank values
                    // self.tableView.reloadData()
                    self.refreshControl?.endRefreshing()
                    println("refreshed")
                }
            } else {
                if HttpClient.isAccessDeniedCode(status) {
                    AppManager.sharedInstance.logout()
                    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                    appDelegate.showLoginScreen(false)
                }
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return AppManager.sharedInstance.numSections()
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AppManager.sharedInstance.numCellsInSection(section)
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "ChannelTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! ChannelTableViewCell

        var channel = AppManager.sharedInstance.getChannelInSectionAtIndex(
            indexPath.section,
            index: indexPath.row)!
        
        initChannelCell(cell, channel: channel)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCellWithIdentifier("HeaderTableViewCell") as! HeaderTableViewCell
        
        if let header = AppManager.sharedInstance.getHeaderInSection(section) {
            cell.headerLabel.text = header
            cell.headerLabel.textColor = SyncopateStyle.mainTextColor
            cell.backgroundColor = SyncopateStyle.mainSeparatorColor
            return cell
        }
        
        return nil
    }
    
    func initChannelCell(cell: ChannelTableViewCell, channel: ChannelState) {
        // Assign text
        // cell.groupLabel.text = channel.group
        // cell.topicLabel.text = "\(channel.group).\(channel.topic)"
        cell.topicLabel.text = channel.label
        cell.valueLabel.text = channel.value
        
        // Set color and font size
        cell.contentView.backgroundColor = SyncopateStyle.mainBackgroundColor
        // cell.groupLabel.textColor = SyncopateStyle.mainTextColor
        // cell.groupLabel.font = cell.groupLabel.font.fontWithSize(SyncopateStyle.mainGroupFontSize)
        
        cell.topicLabel.textColor = SyncopateStyle.mainHighlightColor
        cell.topicLabel.font = cell.topicLabel.font.fontWithSize(SyncopateStyle.mainTopicFontSize)
        
        cell.valueLabel.textColor = SyncopateStyle.mainTextColor
        cell.valueLabel.font = cell.valueLabel.font.fontWithSize(SyncopateStyle.mainValueFontSize)
        channel.setValueLabel(cell.valueLabel)
        // println("\(indexPath.row): \(channel.description())")
        
        // Selection colors
        cell.selectionStyle = UITableViewCellSelectionStyle.Default
        var bgColorView = UIView()
        bgColorView.backgroundColor = SyncopateStyle.mainSelectedColor
        cell.selectedBackgroundView = bgColorView
        cell.backgroundColor = SyncopateStyle.mainBackgroundColor
        
        // Get rid of inset
        cell.layoutMargins = UIEdgeInsetsZero
        cell.preservesSuperviewLayoutMargins = false
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return SyncopateStyle.mainRowHeight
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
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if segue.identifier == "showTopicView" {
            if let navController = segue.destinationViewController as? UINavigationController {
                if var vc = navController.topViewController as? TopicViewController {
                    if let indexPath = self.tableView.indexPathForSelectedRow() {
                        let c = AppManager.sharedInstance.getChannelInSectionAtIndex(indexPath.section, index: indexPath.row)!
                        AppManager.sharedInstance.setSelectedChannel(c.group, topic: c.topic)
                    }
                }
            }
        }
    }


}
