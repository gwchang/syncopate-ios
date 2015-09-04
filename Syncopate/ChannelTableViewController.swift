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
    var channels = [ChannelState]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadSampleChannels()
        
        self.tableView.backgroundColor = SyncopateStyle.backgroundColor
        self.tableView.separatorColor = SyncopateStyle.darkColor
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        self.tableView.separatorInset = UIEdgeInsetsZero
    }
    
    func loadSampleChannels() {
        let channel1 = ChannelState(
            group: "top",
            topic: "cpu_usage_user",
            value: "25%")!
        let channel2 = ChannelState(
            group: "top",
            topic:"cpu_usage_sys",
            value: "75%")!
        channels += [ channel1, channel2 ]
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
        return channels.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "ChannelTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! ChannelTableViewCell

        let channel = channels[indexPath.row]
        
        // Assign text
        cell.groupLabel.text = channel.group
        cell.topicLabel.text = channel.topic
        cell.valueLabel.text = channel.value
        
        // Set color and font size
        cell.contentView.backgroundColor = SyncopateStyle.backgroundColor
        cell.groupLabel.textColor = SyncopateStyle.textColor
        cell.groupLabel.font = cell.groupLabel.font.fontWithSize(20)
        
        cell.topicLabel.textColor = SyncopateStyle.highlightColor
        cell.topicLabel.font = cell.topicLabel.font.fontWithSize(20)
        
        cell.valueLabel.textColor = SyncopateStyle.textColor
        cell.valueLabel.font = cell.valueLabel.font.fontWithSize(60)
        
        // cell.separatorInset = UIEdgeInsetsZero
        // cell.layoutMargins = UIEdgeInsetsZero
        
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
