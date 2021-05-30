//
//  MyPostsViewController.swift
//  Dock: Computer Science
//
//  Created by Leon Djusberg on 7/6/18.
//  Copyright © 2018 Leon Djusberg. All rights reserved.
//

import UIKit
import Firebase

class MyPostsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var myPostsTable: UITableView!
    
    var myPosts : [MyPost] = []
    var collRef : CollectionReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myPostsTable.delegate = self
        myPostsTable.dataSource = self
        
        self.navigationItem.rightBarButtonItem = editButtonItem
        
        if Auth.auth().currentUser?.uid != nil {
            collRef = Firestore.firestore().collection("Users").document(Auth.auth().currentUser!.uid).collection("myPosts")
        retrieveMyPosts()
        }
    }
    
    func retrieveMyPosts() {
        collRef.getDocuments() { (querySnapshot, error) in
            
            if let error = error {
                print("Could not find document: \(error)")
                return
            } else {
                for document in querySnapshot!.documents {
                    let myData = document.data()
                    let college = myData["college"] as! String
                    let type = myData["type"] as! String
                    let content = myData["content"] as! String
                    let time = myData["time"] as! NSNumber
                    let key = myData["key"] as! String
                    let postInfo = MyPost(postCollege: college, postType: type, postContent: content, postTime: time, postKey: key)
                    self.myPosts.append(postInfo)
                }
            }
            self.myPosts.sort { Double(truncating: $0.postTime) > Double(truncating: $1.postTime) }
            self.myPostsTable.reloadData()
        }
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        self.myPostsTable.setEditing(editing, animated: animated)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myPosts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myPostsTable.dequeueReusableCell(withIdentifier: "myPost", for: indexPath) as! MyPostsTableViewCell
        
        cell.postCollege.text = "Post College : \(myPosts[indexPath.row].postCollege)"
        cell.postContent.text = "Post Content : \"\(myPosts[indexPath.row].postContent)\""
        cell.postType.text = "Post Type : \(myPosts[indexPath.row].postType)"
        let timePosted = myPosts[indexPath.row].postTime
        let postDate = Date(timeIntervalSince1970: TimeInterval(truncating: timePosted))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy  |  HH:mm:ss zzz"
        let strDate = dateFormatter.string(from: postDate)
        cell.postTimestamp.text = "Post Time : \(strDate)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
        Firestore.firestore().collection("Colleges").document(myPosts[indexPath.row].postCollege).collection(myPosts[indexPath.row].postType).document(myPosts[indexPath.row].postKey).delete()
        Firestore.firestore().collection("Users").document(Auth.auth().currentUser!.uid).collection("myPosts").document(myPosts[indexPath.row].postKey).delete()
            
            myPosts.remove(at: indexPath.row)
            myPostsTable.deleteRows(at: [indexPath], with: .fade)
            
        }
    }
}
