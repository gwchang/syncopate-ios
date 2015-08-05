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

    @IBOutlet weak var dataSourceButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.dataSourceLabel.text = "http://localhost:8080/clusters/55aed92950db53426a000001";
        self.dataSourceLabel.lineBreakMode = .ByWordWrapping;
        self.dataSourceLabel.numberOfLines = 0;
        
        self.dataSourceTextField.text = self.dataSourceLabel.text;
        
        self.dataSourceButton.setTitle("Submit", forState: .Normal);
        self.dataSourceButton.addTarget(self, action: "handleDataSourceButtonClick:", forControlEvents: .TouchUpInside);
    }
    
    func handleDataSourceButtonClick(sender:UIButton!) {
        println("Button pressed");
        self.dataSourceLabel.text = self.dataSourceTextField.text;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

