//
//  ViewController.swift
//  Syncopate
//
//  Created by Gary Chang on 8/5/15.
//  Copyright (c) 2015 Gary Chang. All rights reserved.
//

import UIKit

func colorWithHexString(hex:String) -> UIColor {
    var cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).uppercaseString
    
    if (cString.hasPrefix("#")) {
        cString = (cString as NSString).substringFromIndex(1)
    }
    
    if (count(cString) != 6) {
        return UIColor.grayColor()
    }
    
    var rString = (cString as NSString).substringToIndex(2)
    var gString = ((cString as NSString).substringFromIndex(2) as NSString).substringToIndex(2)
    var bString = ((cString as NSString).substringFromIndex(4) as NSString).substringToIndex(2)
    
    var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
    NSScanner(string: rString).scanHexInt(&r)
    NSScanner(string: gString).scanHexInt(&g)
    NSScanner(string: bString).scanHexInt(&b)
    
    
    return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
}

class ViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dataSourceLabel: UILabel!
    @IBOutlet weak var dataSourceTextField: UITextField!

    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet weak var keyLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    var intervalTimer: NSTimer?
    var counter = 0;
    var lastKey = "[key]";
    var lastValue = "[value]";
    var lastTimestamp = "0";
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let textColor = colorWithHexString("#fff6e5");
        
        self.titleLabel.textColor = textColor;
        self.titleLabel.font = self.titleLabel.font.fontWithSize(30);
        self.dataSourceLabel.text = "http://localhost:8080/clusters/55aed92950db53426a000002";
        self.dataSourceLabel.textColor = textColor;
            
        /*
        self.dataSourceLabel.text = "http://jsonplaceholder.typicode.com/posts/1"
        */
        self.dataSourceLabel.lineBreakMode = .ByWordWrapping;
        self.dataSourceLabel.numberOfLines = 0;
        
        self.dataSourceTextField.text = self.dataSourceLabel.text;
        
        self.startButton.setTitle("Start", forState: .Normal);
        self.startButton.addTarget(self, action: "handleStartButtonClick:", forControlEvents: .TouchUpInside);
        //self.startButton.setTitleColor(UIColor.greenColor(), forState: UIControlState.Normal)
        self.startButton.backgroundColor = UIColor.clearColor();
        self.startButton.layer.cornerRadius = 5
        self.startButton.layer.borderWidth = 1
        self.startButton.layer.borderColor = textColor.CGColor;
        self.startButton.setTitleColor(textColor, forState: .Normal);
        
        self.stopButton.setTitle("Stop", forState: .Normal);
        self.stopButton.addTarget(self, action: "handleStopButtonClick:", forControlEvents: .TouchUpInside);
        self.stopButton.backgroundColor = UIColor.clearColor();
        self.stopButton.layer.cornerRadius = 5
        self.stopButton.layer.borderWidth = 1
        self.stopButton.layer.borderColor = textColor.CGColor; //self.view.tintColor.CGColor
        self.stopButton.setTitleColor(textColor, forState: .Normal);
        
        self.counterLabel.textColor = textColor;
        updateCount(self.counter);
        self.keyLabel.text = self.lastKey;
        self.valueLabel.text = self.lastValue;
        self.timeLabel.text = "Timestamp: \(self.lastTimestamp)";
        self.timeLabel.textColor = textColor;
        
        // Background
        self.view.backgroundColor = colorWithHexString("#3e454c");
    }
    
    func updateCount(count: Int) {
        self.counterLabel.text = "Count: " + String(self.counter);
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
        updateCount(++self.counter);
        
        println("Timer: " + String(self.counter));
        getData();
        self.keyLabel.text = self.lastKey;
        self.keyLabel.setNeedsDisplay();
        self.valueLabel.text = self.lastValue;
        self.valueLabel.setNeedsDisplay();
        self.timeLabel.text = "Timestamp: \(self.lastTimestamp)";
        self.timeLabel.setNeedsDisplay();
    }
    
    func handleStopButtonClick(sender:UIButton!) {
        self.intervalTimer?.invalidate();
        self.intervalTimer = nil;
        
        self.counter = 0;
        updateCount(self.counter);
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
        
        println(request.URL!);
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue(), completionHandler:{ (response:NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            if error != nil {
                println("ERROR: " + request.URL!.absoluteString!);
                println(error.description);
            } else {
                var error: AutoreleasingUnsafeMutablePointer<NSError?> = nil
                
                let jsonResult: NSDictionary! = NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingOptions.MutableContainers, error: error) as? NSDictionary
                
                if (jsonResult != nil) {
                    // println(jsonResult);
                    if let series = jsonResult["Series"] as? NSArray {
                        if series.count > 0 {
                            if let last = series[series.count-1] as? NSDictionary {
                                // println(last);
                                if let updateTimestamp : AnyObject = last["LastUpdate"] {
                                    if let snapshot = last["Snapshot"] as? NSDictionary {
                                        // println(snapshot);
                                        for (k,v) in snapshot {
                                            self.lastTimestamp = "\(updateTimestamp)";
                                            self.lastKey = "\(k)";
                                            self.lastValue = "\(v)";
                                        }
                                        /*
                                        if let k = snapshot["Key"] as? String {
                                            if let v : AnyObject = snapshot["Value"] {
                                                self.lastValue = "\(v)";
                                                    self.lastKey = k;
                                            self.lastTimestamp = "\(updateTimestamp)";
                                            }
                                        }
                                        */
                                    }
                                }
                            }
                        }
                    }
                } else {
                    println("ERROR: Unable to parse json " +
                        request.URL!.absoluteString!);
                }
            }
        })
    }


}

