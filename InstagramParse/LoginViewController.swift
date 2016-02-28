//
//  LoginViewController.swift
//  InstagramParse
//
//  Created by Kevin Tran on 2/28/16.
//  Copyright © 2016 Kevin Tran. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {

    @IBOutlet weak var loginField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onSignUp(sender: UIButton) {
        let newUser = PFUser()
        
        newUser.username = loginField.text
        newUser.password = passwordField.text
        newUser.signUpInBackgroundWithBlock { (success: Bool,error: NSError?) -> Void in
            if success {
                print("User created successfully")
                self.performSegueWithIdentifier("loginSegue", sender: nil)

            } else {
                print("User creation failed with error: \(error?.localizedDescription)")
                
                //add all error code later
                if error!.code == 202 {
                    let alertController = UIAlertController(title: "Error", message: "Username is taken", preferredStyle: .Alert)
                    // create an OK action
                    let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                        // handle response here.
                    }
                    // add the OK action to the alert controller
                    alertController.addAction(OKAction)
                    
                    self.presentViewController(alertController, animated: true) {
                        // optional code for what happens after the alert controller has finished presenting
                    }
                    
                }
            }
        }
    }

    @IBAction func onSignIn(sender: AnyObject) {
        PFUser.logInWithUsernameInBackground(loginField.text!, password: passwordField.text!) { (user: PFUser?, error: NSError?) -> Void in
            if user != nil {
                print("You're login")
                self.performSegueWithIdentifier("loginSegue", sender: nil)
            } else {
                print(error?.localizedDescription)
            }
        }
        
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
