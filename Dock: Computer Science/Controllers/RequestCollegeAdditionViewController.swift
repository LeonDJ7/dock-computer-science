//
//  RequestCollegeAdditionViewController.swift
//  Dock: Computer Science
//
//  Created by Leon Djusberg on 8/4/18.
//  Copyright © 2018 Leon Djusberg. All rights reserved.
//

import UIKit
import Firebase

class RequestCollegeAdditionViewController: UIViewController {

    @IBOutlet weak var requestAdditionBtn: UIButton!
    @IBOutlet weak var collegeTF: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        requestAdditionBtn.layer.cornerRadius = requestAdditionBtn.frame.height / 5
    }

    @IBAction func confirmRequest(_ sender: Any) {
        
        Firestore.firestore().collection("Missing Colleges").getDocuments { (querySnapshot, error) in
            Firestore.firestore().collection("Missing Colleges").document("\((querySnapshot?.documents.count)! + 1)").setData(["college" : self.collegeTF.text!])
            self.collegeTF.text = ""
        }
        
    }
}
