//
//  ChatViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
class ChatViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    //array of message object
    var messages : [Message] = [
        Message(sender: "1@2.com", body: "Hey"), Message(sender: "a@b.com", body: "Hello!"), Message(sender: "1@2.com", body: "What's up")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self;
       // tableView.delegate = self;
        //hides  back button in Chat VIewController
        navigationItem.hidesBackButton = true;
        title = K.title;
        //register Nib file
        
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        

    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
    }
    
    
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        let firebaseAuth = Auth.auth()
        navigationController?.popToRootViewController(animated: true)
    do {
      try firebaseAuth.signOut()
    } catch let signOutError as NSError {
      print("Error signing out: %@", signOutError)
    }
      
    }
    
}

//MARK: Datasource protocol : populate table view
extension ChatViewController: UITableViewDataSource{
    //number of cells = array elements
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count;
    }
    //indexPath is position
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Box standard UITableViewCell
       // let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath);
        
        //Message cell as Object class
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MessageCell;        //cell.textLabel?.text = messages[indexPath.row].body
        cell.label.text = messages[indexPath.row].body;
        return cell;
    }
    
    
}

//MARK: tableView Delegate protocol

/*  Chat App not need of selection for user
 extension ChatViewController:UITableViewDelegate{
    //row interacted by user
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    
}
*/
