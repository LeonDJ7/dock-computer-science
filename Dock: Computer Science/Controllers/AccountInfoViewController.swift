//
//  AccountInfoViewController.swift
//  Dock: Computer Science
//
//  Created by Leon Djusberg on 6/4/18.
//  Copyright © 2018 Leon Djusberg. All rights reserved.
//

import UIKit
import Firebase

class AccountInfoViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    
    

    @IBOutlet weak var collegeSearchBar: UISearchBar!
    @IBOutlet weak var logInBtn: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var displayNameLbl: UILabel!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var displayNameTF: UITextField!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var jobTitleTF: UITextField!
    @IBOutlet weak var employerTF: UITextField!
    @IBOutlet weak var yearOfGraduationTF: UITextField!
    @IBOutlet weak var jobTitleLbl: UILabel!
    @IBOutlet weak var employerLbl: UILabel!
    @IBOutlet weak var collegeLbl: UILabel!
    @IBOutlet weak var yearOfGraduationLbl: UILabel!
    @IBOutlet weak var updateBtn: UIButton!
    @IBOutlet weak var logOutBtn: UIButton!
    @IBOutlet weak var collegeTable: UITableView!
    var yearArray : [String] = ["","1950", "1951", "1952", "1953", "1954", "1955", "1956", "1957", "1958", "1959", "1960", "1961", "1962", "1963", "1964", "1965", "1966", "1967", "1968", "1969", "1970", "1971", "1972", "1973", "1974", "1975", "1976", "1977", "1978", "1979", "1980", "1981", "1982", "1983", "1984", "1985", "1986", "1987", "1988", "1989", "1990", "1991", "1992", "1993", "1994", "1995", "1996", "1997", "1998", "1999", "2000", "2001", "2002", "2003", "2004", "2005", "2006", "2007", "2008", "2009", "2010", "2011", "2012", "2013", "2014", "2015", "2016", "2017", "2018", "2019", "2020", "2021", "2022"]
    var yearPicker = UIPickerView()
    var collegeArray : [String] = []
    var filteredColleges = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collegeSearchBar.delegate = self
        collegeTable.delegate = self
        collegeTable.dataSource = self
        
        if Auth.auth().currentUser?.uid == nil {
            displayNameLbl.isHidden = true
            displayNameTF.isHidden = true
            emailTF.isHidden = true
            emailLbl.isHidden = true
            jobTitleTF.isHidden = true
            jobTitleLbl.isHidden = true
            employerTF.isHidden = true
            employerLbl.isHidden = true
            collegeSearchBar.isHidden = true
            collegeLbl.isHidden = true
            yearOfGraduationTF.isHidden = true
            yearOfGraduationLbl.isHidden = true
            logInBtn.isHidden = false
            signUpBtn.isHidden = false
            updateBtn.isHidden = true
            logOutBtn.isHidden = true
        } else {
            populateCollegeArray()
        }
        
        yearPicker.tag = 1
        signUpBtn.layer.cornerRadius = signUpBtn.frame.height / 5
        logInBtn.layer.cornerRadius = logInBtn.frame.height / 5
        updateBtn.layer.cornerRadius = updateBtn.frame.height / 5
        logOutBtn.layer.cornerRadius = logOutBtn.frame.height / 5
        scrollView.keyboardDismissMode = .onDrag
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(donePicker))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        setCustomBackImage()
        
        yearOfGraduationTF.inputAccessoryView = toolBar
        
        yearPicker.delegate = self
        yearPicker.dataSource = self
        yearOfGraduationTF.inputView = yearPicker
        
        let textFieldInsideUISearchBar = collegeSearchBar.value(forKey: "searchField") as? UITextField
        let fontDescriptor = UIFontDescriptor(name: "Menlo-Regular", size: 17)
        textFieldInsideUISearchBar?.font = UIFont(descriptor: fontDescriptor, size: 17)
    }
    
    @IBAction func logOutTapped(_ sender: Any) {
        createAlert(title: "Just Checking", message: "Are you sure you want to log out?")
    }
    
    @IBAction func updateBtnTapped(_ sender: Any) {
        
        guard let email = emailTF.text,
            email != "",
            let displayName = displayNameTF.text,
            displayName != ""
            else {
                AlertController.showAlert(self, title: "Missing Info", message: "Name and email are required fields")
                return
        }
        let jobTitle = jobTitleTF.text
        let employer = employerTF.text
        let college = collegeSearchBar.text
        let yearOfGraduation = yearOfGraduationTF.text
        
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = displayName
        changeRequest?.commitChanges { (error) in
            guard error == nil else {
                AlertController.showAlert(self, title: "Error", message: error!.localizedDescription)
                return
            }
        }
        
        if jobTitle == "" && employer != "" {
            AlertController.showAlert(self, title: "Missing Info", message: "You must fill out job title if you have an employer")
            return
        }
        
        if college! != "" && yearOfGraduation == "" || college! == "" && yearOfGraduation != "" {
            AlertController.showAlert(self, title: "Missing Info", message: "Please fill out college and year of graduation, or neither")
            return
        }
        
        let userData : [String : Any] = ["displayName" : displayName,
                                         "jobTitle" : jobTitle!,
                                         "employer" : employer!,
                                         "college" : college!,
                                         "yearOfGraduation" : yearOfGraduation!]
        
        // change data in firebase
        
        Firestore.firestore().collection("Users").document((Auth.auth().currentUser?.uid)!).setData(userData)
        AlertController.showAlert(self, title: "Success", message: "User info saved successfully")
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredColleges.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = collegeTable.dequeueReusableCell(withIdentifier: "collegeCell", for: indexPath) as! AccountInfoTableViewCell
        
        cell.collegeLbl.text = filteredColleges[indexPath.row]
        
        return cell
    }
    
    
    func createAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "No", style: .destructive, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
            }
            self.performSegue(withIdentifier: "logOutSegue", sender: self)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return yearArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        yearOfGraduationTF.text = yearArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return yearArray[row]
    }
    
    func populateCollegeArray() {
        let db = Firestore.firestore()
        db.collection("Colleges").getDocuments { (querySnapshot, err) in
            if let err = err
            {
                print("Error getting documents: \(err)")
            }
            else
            {
                self.collegeArray.append("")
                for document in querySnapshot!.documents {
                    self.collegeArray.append(document.documentID)
                    self.filteredColleges = self.collegeArray
                    self.collegeTable.reloadData()
                }
                Firestore.firestore().collection("Users").document((Auth.auth().currentUser?.uid)!).getDocument { (document, error) in
                    let userData : [String : Any] = (document?.data())!
                    let displayName = userData["displayName"] as! String
                    let college = userData["college"] as! String
                    let yearOfGraduation = userData["yearOfGraduation"] as! String
                    let employer = userData["employer"] as! String
                    let jobTitle = userData["jobTitle"] as! String
                    let email = Auth.auth().currentUser?.email
                    self.displayNameTF.text = displayName
                    self.yearOfGraduationTF.text = yearOfGraduation
                    self.employerTF.text = employer
                    self.jobTitleTF.text = jobTitle
                    self.emailTF.text = email
                    self.collegeSearchBar.text = college
                    let yearIndex = self.yearArray.index(of: yearOfGraduation)
                    self.yearPicker.selectRow(yearIndex!, inComponent: 0, animated: false)
                }
            }
        }
    }
    
    @objc func donePicker() {
        
        yearOfGraduationTF.resignFirstResponder()
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        collegeSearchBar.text = filteredColleges[indexPath.row]
        resignFirstResponder()
        collegeTable.isHidden = true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        
        collegeTable.isHidden = false
        
        
        guard !searchText.isEmpty else {
            filteredColleges = collegeArray
            collegeTable.isHidden = true
            return
        }
        
        filteredColleges = collegeArray.filter({ (college) -> Bool in
            
            return college.lowercased().contains(searchText.lowercased())
        })
        collegeTable.reloadData()
    }
    
    func setCustomBackImage() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}
