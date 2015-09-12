//
//  LoginViewController.swift
//  Syncopate
//
//  Created by Gary Chang on 9/11/15.
//  Copyright (c) 2015 Gary Chang. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var loginButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.welcomeLabel.textColor = SyncopateStyle.menuTextColor
        self.view.backgroundColor = SyncopateStyle.menuBackgroundColor
        self.loginView.backgroundColor = SyncopateStyle.menuBackgroundColor
        
        usernameTextField.placeholder = "Username";
        usernameTextField.autocorrectionType = UITextAutocorrectionType.No;
        usernameTextField.clearButtonMode = UITextFieldViewMode.WhileEditing
        
        passwordTextField.placeholder = "Password";
        passwordTextField.autocorrectionType = UITextAutocorrectionType.No;
        passwordTextField.clearButtonMode = UITextFieldViewMode.WhileEditing
        
        // Initialize buttons
        loginButton.setTitle("Login", forState: .Normal);
        loginButton.addTarget(self, action: "handleLoginButtonClick:", forControlEvents: .TouchUpInside);
        loginButton.backgroundColor = UIColor.clearColor();
        loginButton.layer.cornerRadius = 5
        loginButton.layer.borderWidth = 1
        loginButton.layer.borderColor = SyncopateStyle.menuTextColor.CGColor
        loginButton.setTitleColor(SyncopateStyle.menuTextColor, forState: .Normal);
    }
    
    func handleLoginButtonClick(sender:UIButton!) {
        println("login")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
