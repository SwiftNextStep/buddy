//
//  JSQViewController.swift
//  buddy2.2
//
//  Created by admin on 4/28/16.
//  Copyright © 2016 NguyenBui. All rights reserved.
//

import UIKit
import JSQMessagesViewController


class JSQViewController: JSQMessagesViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.senderId = "uidFromFirebase"
        self.senderDisplayName = "username"
        // Do any additional setup after loading the view.
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
