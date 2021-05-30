//
//  AddPostPopupViewController.swift
//  Dock: Computer Science
//
//  Created by Leon Djusberg on 6/16/18.
//  Copyright © 2018 Leon Djusberg. All rights reserved.
//

import UIKit
import Firebase
import GoogleMobileAds

class AddPostPopupViewController: UIViewController, GADInterstitialDelegate {

    @IBOutlet weak var postBtn: UIButton!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var postTypeLbl: UILabel!
    @IBOutlet weak var popUpView: UIView!
    var interstitial: GADInterstitial!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        textView.layer.cornerRadius = 10
        popUpView.layer.cornerRadius = 10
        postBtn.layer.cornerRadius = postBtn.frame.height / 5
        if isShowingReviews == true {
            postTypeLbl.text = "Reviews"
        } else {
            postTypeLbl.text = "Advice"
        }
        
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-2790005755690511/6266565653")
        interstitial.delegate = self
        let interstitialRequest = GADRequest()
        interstitial.load(interstitialRequest)
        interstitial = createAndLoadInterstitial()
        
    }
    
    func createAndLoadInterstitial() -> GADInterstitial {
        let interstitial = GADInterstitial(adUnitID: "ca-app-pub-2790005755690511/6266565653")
        interstitial.delegate = self
        let interstitialRequest = GADRequest()
        interstitial.load(interstitialRequest)
        return interstitial
    }
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        interstitial = createAndLoadInterstitial()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func dismissPopup(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func post(_ sender: Any) {
        
        guard let postText = textView.text,
            postText != ""
            else { return }
        let postTimestamp = Date().timeIntervalSince1970
        var userData : [String : Any] = [:]
        
        Firestore.firestore().collection("Users").document((Auth.auth().currentUser?.uid)!).getDocument { (document, error) in
            userData = (document?.data())!
            
            if isShowingReviews == true {
            
                var postData : [String : Any] = [:]
                
                if userData["employer"] as! String == "" && userData["college"] as! String == "" && userData["jobTitle"] as! String == "" {
                    postData = ["Poster" : "\(String(describing: Auth.auth().currentUser!.displayName!))",
                        "Review" : postText,
                        "Timestamp" : postTimestamp]
                } else if userData["employer"] as! String == "" && userData["jobTitle"] as! String == "" && userData["college"] as! String != "" {
                    postData = ["Poster" : "\(String(describing: Auth.auth().currentUser!.displayName!)) - \(String(describing: userData["college"]!)) class of \(String(describing: userData["yearOfGraduation"]!))",
                        "Review" : postText,
                        "Timestamp" : postTimestamp]
                } else if userData["employer"] as! String != "" && userData["jobTitle"] as! String != "" && userData["college"] as! String == "" {
                    postData = ["Poster" : "\(Auth.auth().currentUser!.displayName!) - \(String(describing: userData["jobTitle"]!)) at \(String(describing: userData["employer"]!))",
                        "Review" : postText,
                        "Timestamp" : postTimestamp]
                } else if userData["employer"] as! String == "" && userData["jobTitle"] as! String != "" && userData["college"] as! String == "" {
                    postData = ["Poster" : "\(String(describing: Auth.auth().currentUser!.displayName!)) - \(String(describing: userData["jobTitle"]!))",
                        "Review" : postText,
                        "Timestamp" : postTimestamp]
                } else if userData["employer"] as! String == "" && userData["jobTitle"] as! String != "" && userData["college"] as! String != "" {
                    postData = ["Poster" : "\(String(describing: Auth.auth().currentUser!.displayName!)) - \(String(describing: userData["jobTitle"]!)) - \(String(describing: userData["college"]!)) class of \(String(describing: userData["yearOfGraduation"]!))",
                        "Review" : postText,
                        "Timestamp" : postTimestamp]
                } else {
                    postData = ["Poster" : "\(String(describing: Auth.auth().currentUser!.displayName!)) - \(String(describing: userData["jobTitle"]!)) at \(String(describing: userData["employer"]!)) - \(String(describing: userData["college"]!)) class of \(String(describing: userData["yearOfGraduation"]!))",
                        "Review" : postText,
                        "Timestamp" : postTimestamp]
                }
                
                let ref = Firestore.firestore().collection("Colleges").document(selectedCollege).collection("Reviews").document()
            let documentID = ref.documentID
                ref.setData(postData)
                let myPostData : [String : Any] = ["college" : selectedCollege,
                                                           "type" : self.postTypeLbl.text!,
                                                           "content" : postText,
                                                           "time" : postTimestamp,
                                                           "key" : documentID]
        Firestore.firestore().collection("Users").document(Auth.auth().currentUser!.uid).collection("myPosts").document(documentID).setData(myPostData)
            Firestore.firestore().collection("All Posts").getDocuments(completion: { (QuerySnapshot, error) in
                Firestore.firestore().collection("All Posts").document("\((QuerySnapshot?.documents.count)! + 1)").setData(postData)
            })
                
            } else {
                
                var postData : [String : Any] = [:]
                
                if userData["employer"] as! String == "" && userData["college"] as! String == "" && userData["jobTitle"] as! String == "" {
                    postData = ["Poster" : "\(String(describing: Auth.auth().currentUser!.displayName!))",
                        "Advice" : postText,
                        "Timestamp" : postTimestamp]
                    print(1)
                } else if userData["employer"] as! String == "" && userData["jobTitle"] as! String == "" && userData["college"]! as! String != "" {
                    postData = ["Poster" : "\(String(describing: Auth.auth().currentUser!.displayName!)) - \(String(describing: userData["college"]!)) Class of \(String(describing: userData["yearOfGraduation"]!))",
                        "Advice" : postText,
                        "Timestamp" : postTimestamp]
                    print(2)
                } else if userData["employer"] as! String != "" && userData["jobTitle"] as! String != "" && userData["college"] as! String == "" {
                    postData = ["Poster" : "\(String(describing: Auth.auth().currentUser!.displayName!)) - \(String(describing: userData["jobTitle"]!)) at \(String(describing: userData["employer"]!))",
                        "Advice" : postText,
                        "Timestamp" : postTimestamp]
                    print(3)
                } else if userData["employer"] as! String == "" && userData["jobTitle"] as! String != "" && userData["college"] as! String == "" {
                    postData = ["Poster" : "\(String(describing: Auth.auth().currentUser!.displayName!)) - \(String(describing: userData["jobTitle"]))",
                        "Advice" : postText,
                        "Timestamp" : postTimestamp]
                    print(4)
                } else if userData["employer"] as! String == "" && userData["jobTitle"] as! String != "" && userData["college"] as! String != "" {
                    postData = ["Poster" : "\(String(describing: Auth.auth().currentUser!.displayName!)) - \(String(describing: userData["jobTitle"]!)) - \(String(describing: userData["college"]!)) Class of \(String(describing: userData["yearOfGraduation"]))",
                        "Advice" : postText,
                        "Timestamp" : postTimestamp]
                    print(5)
                } else {
                    postData = ["Poster" : "\(String(describing: Auth.auth().currentUser!.displayName!)) - \(String(describing: userData["jobTitle"]!)) at \(String(describing: userData["employer"]!)) - \(String(describing: userData["college"]!)) Class of \(String(describing: userData["yearOfGraduation"]!))",
                        "Advice" : postText,
                        "Timestamp" : postTimestamp]
                    print(6)
                }
                
                let ref = Firestore.firestore().collection("Colleges").document(selectedCollege).collection("Advice").document()
                let documentID = ref.documentID
                ref.setData(postData)
                let myPostData : [String : Any] = ["college" : selectedCollege,
                                                   "type" : self.postTypeLbl.text!,
                                                   "content" : postText,
                                                   "time" : postTimestamp,
                                                   "key" : documentID]
                Firestore.firestore().collection("Users").document(Auth.auth().currentUser!.uid).collection("myPosts").document(documentID).setData(myPostData)
                Firestore.firestore().collection("All Posts").getDocuments(completion: { (QuerySnapshot, error) in
                    Firestore.firestore().collection("All Posts").document("\((QuerySnapshot?.documents.count)! + 1)").setData(postData)
                })
            }
        }
        
        
        let randomNumber = arc4random_uniform(3)
        
        if randomNumber == 0 {
            
            if interstitial.isReady {
                interstitial.present(fromRootViewController: self)
                print("interstitial ready")
            } else {
                self.dismiss(animated: true, completion: nil)
                print("interstitial not ready")
            }
        } else {
            self.dismiss(animated: true, completion: nil)
            print("random number not correct")
        }
    }
}
