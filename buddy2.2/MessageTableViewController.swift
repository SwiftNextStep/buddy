//
//  MessageTableViewController.swift
//  buddy2.2
//
//  Created by admin on 4/28/16.
//  Copyright © 2016 NguyenBui. All rights reserved.
//

import UIKit
import Firebase

class MessageTableViewController: UITableViewController {
    
    var firebase = Firebase(url:"https://duddy22.firebaseio.com")
    var chieldAddedHandler = FirebaseHandle()
    var listOfMessages = NSMutableDictionary()
    
    let uid = String?()
    
    
    
    @IBAction func addMessage(sender: AnyObject) {
    }
    @IBAction func logout(sender: AnyObject) {
        firebase.unauth()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        chieldAddedHandler = firebase.childByAppendingPath("posts").observeEventType(.Value, withBlock: { (snapshot:FDataSnapshot!) -> Void in
            self.firebaseUpdate(snapshot)
        })
        chieldAddedHandler = firebase.observeEventType(.ChildChanged, withBlock: { (snapshot:FDataSnapshot!) -> Void in
            self.firebaseUpdate(snapshot)
        })
    }
    
    func firebaseUpdate(snapshot: FDataSnapshot){
        if let newMessages = snapshot.value as? NSDictionary{
            print(newMessages)
            for newMessage in newMessages{
                let key = newMessage.key as! String
                let messageExist = (self.listOfMessages[key] != nil)
                if !messageExist{
                    self.listOfMessages.setValue(newMessage.value, forKey: key)
                }
            }
        }
        
        dispatch_async(dispatch_get_main_queue()){[unowned self] in
            self.tableView.reloadData()
        }
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
        return listOfMessages.count
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let messageController = segue.destinationViewController as? MessageViewController {
            messageController.onMessageAvailable = {[weak self]
                (data) in
                if let weakSelf = self {
                    weakSelf.receiveMessageToSend(data)
                }
            }
        }
    }
    
    func receiveMessageToSend(message:String){
        self.firebase.childByAppendingPath("posts").childByAutoId().setValue(["message":message, "sender":firebase.authData.uid])
    }
    
    
    
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        let arrayOfKeys = listOfMessages.allKeys
        let key = arrayOfKeys[indexPath.row]
        let value = listOfMessages[key as! String]
        cell.textLabel?.text = (value as! NSDictionary)["message"] as? String
        return cell
    }
    
    
    
    
}
