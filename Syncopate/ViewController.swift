//
//  ViewController.swift
//  Syncopate
//
//  Created by Gary Chang on 8/5/15.
//  Copyright (c) 2015 Gary Chang. All rights reserved.
//

import UIKit
import Starscream

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

class ViewController: UIViewController, WebSocketDelegate {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var sourceHostTextField: UITextField!
    @IBOutlet weak var sourcePathTextField: UITextField!

    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    var intervalTimer: NSTimer?;
    var counter = 0;
    var lastTimestamp = "0";
    var lastSnapshots = Dictionary<String,String>();
    var viewSnapshots = Dictionary<String,UILabel>();
    var yStart : CGFloat = 320;
    var socket: WebSocket?;
    var wsMode: Bool = true;
    
    func showSnapshot(key: String, value: String) {
        if self.viewSnapshots[key] == nil {
            var valueHeight : CGFloat = 100;
            var keyHeight : CGFloat = 15;
        
            var valueLabel = UILabel(frame: CGRectMake(0, 0, 200, valueHeight));
            valueLabel.center = CGPointMake(160, self.yStart);
            valueLabel.textAlignment = NSTextAlignment.Center
            valueLabel.text = value;
            valueLabel.textColor = colorWithHexString("#fff6e5");
            valueLabel.font = valueLabel.font.fontWithSize(valueHeight);
            self.view.addSubview(valueLabel);
        
            var keyLabel = UILabel(frame: CGRectMake(0, 0, 200, keyHeight));
            keyLabel.center = CGPointMake(160, self.yStart + valueHeight / 2 + 5);
            keyLabel.textAlignment = NSTextAlignment.Center
            keyLabel.text = key;
            keyLabel.textColor = colorWithHexString("#ff7f66");
            keyLabel.font = keyLabel.font.fontWithSize(keyHeight);
            self.view.addSubview(keyLabel);
            self.viewSnapshots[key] = valueLabel;
            self.yStart += valueHeight + keyHeight + 10;
        } else {
            var valueLabel = self.viewSnapshots[key]!;
            valueLabel.text = value;
            valueLabel.setNeedsDisplay();
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let textColor = colorWithHexString("#fff6e5");
        
        self.titleLabel.textColor = textColor;
        self.titleLabel.font = self.titleLabel.font.fontWithSize(30);

        // self.dataSourceLabel.textColor = textColor;
        
        self.sourceHostTextField.text = "localhost:1234";
        self.sourcePathTextField.text = "/ws?series=testcluster.t1000_temp&series=testcluster.t1000_load&series=testcluster.aapl_price";
        
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
        self.timeLabel.text = "Timestamp: \(self.lastTimestamp)";
        self.timeLabel.textColor = textColor;
        
        // Background
        self.view.backgroundColor = colorWithHexString("#3e454c");
    }
    
    func updateCount(count: Int) {
        self.counterLabel.text = "Count: " + String(self.counter);
    }
    
    func handleStartButtonClick(sender:UIButton!) {
        if self.wsMode {
            getDataWebsocket()
        } else {
            self.intervalTimer = NSTimer.scheduledTimerWithTimeInterval(1, // 1 second
                target: self,
                selector: "handleIntervalTimer:",
                userInfo: nil,
                repeats: true)
        }
    }
    
    func handleIntervalTimer(timer: NSTimer) {
        updateCount(++self.counter);
        
        println("Timer: " + String(self.counter));
        getData();
        updateViews();
    }
    
    func updateViews() {
        self.timeLabel.text = "Timestamp: \(self.lastTimestamp)";
        self.timeLabel.setNeedsDisplay();
        
        for (k,v) in self.lastSnapshots {
            showSnapshot(k, value: v);
        }
    }
    
    func handleStopButtonClick(sender:UIButton!) {
        if self.wsMode {
            self.socket?.disconnect();
        } else {
            self.intervalTimer?.invalidate();
            self.intervalTimer = nil;
        }
        self.counter = 0;
        updateCount(self.counter);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func parseData(jsonResult: NSDictionary) {
        // println(jsonResult);
        if let series = jsonResult["Series"] as? NSArray {
            for var i = 0; i < series.count; ++i {
                if let last = series[i] as? NSDictionary {
                    // println(last);
                    if let updateTimestamp : AnyObject = last["LastUpdate"] {
                        if let snapshot = last["Snapshot"] as? NSDictionary {
                            println(snapshot);
                            for (k,v) in snapshot {
                                self.lastTimestamp = "\(updateTimestamp)";
                                self.lastSnapshots["\(k)"] = "\(v)";
                            }
                        }
                    }
                }
            }
        }
    }
    
    func getData() {
        var url : String = "\(self.sourceHostTextField.text)\(self.sourcePathTextField)";
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
                    self.parseData(jsonResult);
                } else {
                    println("ERROR: Unable to parse json " +
                        request.URL!.absoluteString!);
                }
            }
        })
    }
    
    func getDataWebsocket() {
        var socket = WebSocket(url: NSURL(scheme: "ws",
            host: self.sourceHostTextField.text,
            path: self.sourcePathTextField.text)!);
        socket.delegate = self;
        socket.connect();
        self.socket = socket;
    }
    
    ///////////////////////////////////////////////////////////////////
    // Websocket Delegate Methods
    ///////////////////////////////////////////////////////////////////
    
    func websocketDidConnect(ws: WebSocket) {
        println("Websocket is connected: \(self.sourceHostTextField.text)\(self.sourcePathTextField.text)")
    }
    
    func websocketDidDisconnect(ws: WebSocket, error: NSError?) {
        if let e = error {
            println("Websocket is disconnected: \(e.localizedDescription)")
        } else {
            println("Websocket disconnected: \(self.sourceHostTextField.text)\(self.sourcePathTextField.text)")
        }
    }
    
    func websocketDidReceiveMessage(ws: WebSocket, text: String) {
        // println("Received text: \(text)")
        updateCount(++self.counter);
        
        if let data = text.dataUsingEncoding(NSUTF8StringEncoding) {
            // println("\(data)");
            var error: NSError?;
            let jsonResult: NSDictionary! = NSJSONSerialization.JSONObjectWithData(data,
                options:NSJSONReadingOptions.allZeros,
                error: &error) as? NSDictionary;
        
            if (jsonResult != nil) {
                self.parseData(jsonResult);
            } else {
                println("ERROR: Unable to parse text: \(text)");
            }
        }
        updateViews();
    }
    
    func websocketDidReceiveData(ws: WebSocket, data: NSData) {
        println("Received data: \(data.length)")
    }

}

