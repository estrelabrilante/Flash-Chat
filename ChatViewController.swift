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
    //reference to database
    let db = Firestore.firestore();
    //array of message object
  /*  var messages : [Message] = [
        Message(sender: "1@2.com", body: "Hey"), Message(sender: "a@b.com", body: "Hello!"), Message(sender: "1@2.com", body: "What's up")
    ]*/
    
    var messages: [Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self;
       // tableView.delegate = self;
        //hides  back button in Chat VIewController
        navigationItem.hidesBackButton = true;
        title = K.title;
        //register Nib file
        
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        //retrieve data from database
        loadMessages();
 
    }
    //Firebase Firestore to store data, retrieve data and listen for updates data and sort on ddata
    func loadMessages(){
        //sorted in the order of created
        db.collection(K.FStore.collectionName)
            .order(by: K.FStore.dateField)
            .addSnapshotListener {
            
            (querySnapshot, error) in
            //kept messages as empty before each updates
            self.messages = [];
            if let e = error{
                print("Error in retrieving data")
                print(e);
            }
            else{
                //documents : data can be extracted with data property
                if let snapshotDocuments = querySnapshot?.documents{
                    for doc in snapshotDocuments{
                        print(doc.data())
                        let data = doc.data();
                        if let messageSender = data[K.FStore.senderField] as? String, let messageBody = data[K.FStore.bodyField] as? String{
                            let newMessage = Message(sender: messageSender, body: messageBody);
                            self.messages.append(newMessage);
                            
                            DispatchQueue.main.async {
                                self.tableView.reloadData();
                            }
                            
                        }
                        
                        
                    }
                }
               //querySnapshot?.documents[0].data().[K.FStore.senderField]
            }
        }
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
    //saved to database

        if let messageBody = messageTextfield.text,
        let messageSender = Auth.auth().currentUser?.email{
            db.collection(K.FStore.collectionName).addDocument(data: [K.FStore.senderField: messageSender,K.FStore.bodyField:messageBody,K.FStore.dateField:Date().timeIntervalSince1970]) { error in
                if let e = error{
                    print("there was an error savind data to firestore")
                }
                else{
                    print("Successfully save data")
                }
            }
             
            
        }
        
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
