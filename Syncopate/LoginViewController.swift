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
        self.welcomeLabel.textColor = AppStyle.menuTextColor
        self.view.backgroundColor = AppStyle.menuBackgroundColor
        self.loginView.backgroundColor = AppStyle.menuBackgroundColor
        
        if let previousUsername = NSUserDefaults.standardUserDefaults().stringForKey("username") {
            usernameTextField.placeholder = previousUsername
        } else {
            usernameTextField.placeholder = "Username";
        }
        
        usernameTextField.autocorrectionType = UITextAutocorrectionType.No;
        usernameTextField.clearButtonMode = UITextFieldViewMode.WhileEditing
        
        passwordTextField.placeholder = "Password";
        passwordTextField.autocorrectionType = UITextAutocorrectionType.No;
        passwordTextField.clearButtonMode = UITextFieldViewMode.WhileEditing
        
        // Initialize buttons
        loginButton.setTitle("Login", forState: .Normal);
        // loginButton.addTarget(self, action: "handleLoginButtonClick:", forControlEvents: .TouchUpInside);
        loginButton.backgroundColor = UIColor.clearColor();
        loginButton.layer.cornerRadius = 5
        loginButton.layer.borderWidth = 1
        loginButton.layer.borderColor = AppStyle.menuTextColor.CGColor
        loginButton.setTitleColor(AppStyle.menuTextColor, forState: .Normal);
    }
    
    @IBAction func loginAction(sender: AnyObject) {
        // 1.
        usernameTextField.text = "admin"
        passwordTextField.text = "123"
        if (usernameTextField.text == "" || passwordTextField.text == "") {
            let alert = UIAlertView()
            alert.title = "Please enter both a username and password!"
            alert.addButtonWithTitle("OK")
            alert.show()
            return;
        }
        
        // 2.
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        
        print("Logging in with \(usernameTextField.text):\(passwordTextField.text)")
        AppManager.sharedInstance.login(usernameTextField.text!,
            password: passwordTextField.text!,
            callback: loginCallback)
    }
    
    func loginCallback(success: Bool, status: Int?) {
        if success {
            // Save usernmae
            NSUserDefaults.standardUserDefaults().setValue(usernameTextField.text, forKey: "username")
            NSUserDefaults.standardUserDefaults().synchronize()
            
            // Send notification
            let notification = NSNotification(name: "loginSuccessful", object: self)
            NSNotificationCenter.defaultCenter().postNotification(notification)
            
            // TODO: Not sure if this the best place for this function
            AppManager.sharedInstance.updateClusterList()
            
            // Dismiss login screen
            // self.dismissViewControllerAnimated(true, completion: nil)
            performSegueWithIdentifier("showMainView", sender: self)
        } else {
            let alert = UIAlertView()
            alert.title = "Login Failed"
            alert.message = "Wrong username or password."
            alert.addButtonWithTitle("Retry")
            alert.show()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showMainView" {
            // Select the default cluster to view
        }
    }

}
