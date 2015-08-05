//
//  ViewController.swift
//  Syncopate
//
//  Created by Gary Chang on 8/5/15.
//  Copyright (c) 2015 Gary Chang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var dataSourceLabel: UILabel!
    @IBOutlet weak var dataSourceTextField: UITextField!

    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    @IBOutlet weak var counterLabel: UILabel!
    
    var intervalTimer: NSTimer?
    var counter = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.dataSourceLabel.text = "http://localhost:8080/clusters/55aed92950db53426a000001";
        self.dataSourceLabel.lineBreakMode = .ByWordWrapping;
        self.dataSourceLabel.numberOfLines = 0;
        
        self.dataSourceTextField.text = self.dataSourceLabel.text;
        
        self.startButton.setTitle("Start", forState: .Normal);
        self.startButton.addTarget(self, action: "handleStartButtonClick:", forControlEvents: .TouchUpInside);
        
        self.stopButton.setTitle("Stop", forState: .Normal);
        self.stopButton.addTarget(self, action: "handleStopButtonClick:", forControlEvents: .TouchUpInside);
        
        self.counterLabel.text = String(self.counter);
    }
    
    func handleStartButtonClick(sender:UIButton!) {
        self.dataSourceLabel.text = self.dataSourceTextField.text;
        self.intervalTimer = NSTimer.scheduledTimerWithTimeInterval(1, // 1 second
            target: self,
            selector: "handleIntervalTimer:",
            userInfo: nil,
            repeats: true)
    }
    
    func handleIntervalTimer(timer: NSTimer) {
        self.counterLabel.text = String(++self.counter);
        
        println("Timer: " + String(self.counter));
        getData();
    }
    
    func handleStopButtonClick(sender:UIButton!) {
        self.intervalTimer?.invalidate();
        self.intervalTimer = nil;
        
        self.counter = 0;
        self.counterLabel.text = String(self.counter);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getData() {
        var url : String = self.dataSourceLabel.text!;
        var request : NSMutableURLRequest = NSMutableURLRequest()
        request.URL = NSURL(string: url)
        request.HTTPMethod = "GET"
        
        println(request.URL);
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue(), completionHandler:{ (response:NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            if error != nil {
                println(request.URL);
                println(error.description);
            } else {
                var error: AutoreleasingUnsafeMutablePointer<NSError?> = nil
                
                let jsonResult: NSDictionary! = NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingOptions.MutableContainers, error: error) as? NSDictionary
                
                if (jsonResult != nil) {
                    // process jsonResult
                } else {
                    // couldn't load JSON, look at error
                }
            }
        })
    }


}

