//
//  ViewController.swift
//  buddy2.2
//
//  Created by admin on 4/28/16.
//  Copyright © 2016 NguyenBui. All rights reserved.
//

import UIKit
import Firebase


class ViewController: UIViewController {
    var firebase = Firebase(url:"https://duddy22.firebaseio.com")
    var username = String()
    var newUser = Bool()
    
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    @IBAction func login(sender: UIButton) {
        login()
    }
    
    @IBAction func SignUp(sender: UIButton) {
        if checkForBlank() {
            firebase.createUser(emailTextfield.text, password: passwordTextfield.text) { (error: NSError!) in
                if (error != nil) {
                    print(error.localizedDescription)
                    self.displayMessage(error)
                } else {
                    print("new user created ")
                    self.requestForUsername()
                }
            }
        }
    }
    
    func login() {
        if checkForBlank() {
            
            firebase.authUser(emailTextfield.text, password: passwordTextfield.text) { (error: NSError!, authdata:FAuthData!) in
                if (error != nil) {
                    print(error.localizedDescription)
                    self.displayMessage(error)
                    
                } else {
                    print("user logged \(authdata.description)")
                    let uid = authdata.uid
                    if self.newUser{
                        self.firebase.childByAppendingPath("users").childByAppendingPath(uid).setValue(["isOnline": true, "name": self.username])
                        self.performSegueWithIdentifier("mainSegue", sender: self)
                    } else {
                        self.firebase.childByAppendingPath("users").childByAppendingPath(uid).updateChildValues(["isOnline": true])
                        self.retriveUserName()
                        
                    }
                    
                }
            }
        }
    }
    
    func displayMessage(error: NSError) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .Alert)
        let Okaction = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        alert.addAction(Okaction)
        self.presentViewController(alert, animated: true, completion: nil)
        
        
    }
    
    func checkForBlank() -> Bool {
        if ((!emailTextfield.text!.isEmpty) && (!passwordTextfield.text!.isEmpty)) {
            return true
        } else {
            let alert = UIAlertController(title: "Error", message: "Empty field was found", preferredStyle: .Alert)
            let OkAction = UIAlertAction(title: "Ok", style: .Default, handler: nil)
            alert.addAction(OkAction)
            self.presentViewController(alert, animated: true, completion: nil)
            
            return false
        }
    }
    
    func retriveUserName() {
        self.firebase.childByAppendingPath("users").childByAppendingPath(firebase.authData.uid).observeSingleEventOfType(.Value) { (snapshot: FDataSnapshot!) in
            self.username = (snapshot.value as! NSDictionary) ["name"] as! String
            self.performSegueWithIdentifier("segueJSQ", sender: self)
            
        }
    }
    
    func requestForUsername() {
        var textfield = UITextField?()
        let usernameEntry = UIAlertController(title: "User", message: "Please Enter your the Username for your new account", preferredStyle: .Alert)
        let actionOk    = UIAlertAction(title: "Ok", style: .Default) { (UIAlertAction) in
            if let user = textfield?.text{
                print(user)
                self.username = user
                self.newUser = true
                self.login()
            }
        }
        usernameEntry.addAction(actionOk)
        usernameEntry.addTextFieldWithConfigurationHandler { (username: UITextField) in
            textfield = username
        }
        self.presentViewController(usernameEntry, animated: true, completion: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if firebase.authData != nil {
            self.performSegueWithIdentifier("segueJSQ", sender: self)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

