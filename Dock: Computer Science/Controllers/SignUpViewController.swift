//
//  SignUpViewController.swift
//  Dock: Computer Science
//
//  Created by Leon Djusberg on 6/14/18.
//  Copyright © 2018 Leon Djusberg. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {
    

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var displayNameTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var confirmPasswordTF: UITextField!
    @IBOutlet weak var jobTitleTF: UITextField!
    @IBOutlet weak var employerTF: UITextField!
    @IBOutlet weak var collegeTable: UITableView!
    
    @IBOutlet weak var collegeSearchBar: UISearchBar!
    @IBOutlet weak var yearOfGraduationTF: UITextField!
    @IBOutlet weak var signUpBtn: UIButton!
    var yearArray : [String] = ["", "1950", "1951", "1952", "1953", "1954", "1955", "1956", "1957", "1958", "1959", "1960", "1610", "1962", "1963", "1964", "1965", "1966", "1967", "1968", "1969", "1970", "1971", "1972", "1973", "1974", "1975", "1976", "1977", "1978", "1979", "1980", "1981", "1982", "1983", "1984", "1985", "1986", "1987", "1988", "1989", "1990", "1991", "1992", "1993", "1994", "1995", "1996", "1997", "1998", "1999", "2000", "2001", "2002", "2003", "2004", "2005", "2006", "2007", "2008", "2009", "2010", "2011", "2012", "2013", "2014", "2015", "2016", "2017", "2018", "2019", "2020", "2021", "2022"]
    var yearPicker = UIPickerView()
    var collegeArray : [String] = []
    var filteredColleges = [String]()
    
    override func viewDidLoad() {
        
        collegeTable.delegate = self
        collegeTable.dataSource = self
        collegeSearchBar.delegate = self
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBar.sizeToFit()
        scrollView.keyboardDismissMode = .onDrag
        
        let textFieldInsideUISearchBar = collegeSearchBar.value(forKey: "searchField") as? UITextField
        let fontDescriptor = UIFontDescriptor(name: "Menlo-Regular", size: 17)
        textFieldInsideUISearchBar?.font = UIFont(descriptor: fontDescriptor, size: 17)
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(donePicker))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        
        yearOfGraduationTF.inputAccessoryView = toolBar
        super.viewDidLoad()
        signUpBtn.layer.cornerRadius = signUpBtn.frame.height / 5
        populateCollegeArray()
        yearPicker.tag = 1
        yearPicker.delegate = self
        yearPicker.dataSource = self
        yearOfGraduationTF.inputView = yearPicker
    }

    @IBAction func signUpTapped(_ sender: Any) {
        
        guard let email = emailTF.text,
        email != "",
        let displayName = displayNameTF.text,
        displayName != "",
        let password = passwordTF.text,
        password != "",
        let confirmPassword = confirmPasswordTF.text,
        confirmPassword != ""
        else {
            AlertController.showAlert(self, title: "Missing Info", message: "Please fill out all fields correctly")
            return
        }
        
        guard let passwordRequirement = self.passwordTF.text,
            passwordRequirement.count >= 6
            else    {
                AlertController.showAlert(self, title: "Error", message: "Password must be more than 6 characters")
                return
        }
        
        guard let passwordVerification = self.passwordTF.text,
            passwordVerification == self.confirmPasswordTF.text
            else    {
                AlertController.showAlert(self, title: "Error", message: "Password and Confirm Password must be the same")
                return
        }
        
        let jobTitle = jobTitleTF.text
        let employer = employerTF.text
        let college = collegeSearchBar.text
        let yearOfGraduation = yearOfGraduationTF.text
        
        if jobTitle == "" && employer != "" {
            AlertController.showAlert(self, title: "Missing Info", message: "You must fill out job title if you have an employer")
            return
        }
        
        if college! != "" && yearOfGraduation == "" || college! == "" && yearOfGraduation != "" {
            AlertController.showAlert(self, title: "Missing Info", message: "Please fill out college and year of graduation, or neither")
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            
            guard error == nil else {
                AlertController.showAlert(self, title: "Error", message: error!.localizedDescription)
                print ("Error: \(error!.localizedDescription)")
                return
            }
            
            let changeRequest = user?.user.createProfileChangeRequest()
            changeRequest?.displayName = displayName
            changeRequest?.commitChanges { (error) in
                guard error == nil else {
                    AlertController.showAlert(self, title: "Error", message: error!.localizedDescription)
                    return
                }
                
                let userData : [String : Any] = ["displayName" : displayName,
                                                 "jobTitle" : jobTitle!,
                                                 "employer" : employer!,
                                                 "college" : college!,
                                                 "yearOfGraduation" : yearOfGraduation!]
                
                Firestore.firestore().collection("Users").document((user?.user.uid)!).setData(userData)
            }
        }
        self.performSegue(withIdentifier: "toHomeAfterSignUp", sender: self)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 {
            return yearArray.count
        } else {
            return collegeArray.count
        }
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
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredColleges.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = collegeTable.dequeueReusableCell(withIdentifier: "collegeCell", for: indexPath) as! SignUpTableViewCell
        
        cell.collegeLbl.text = filteredColleges[indexPath.row]
        
        return cell
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
    
    @objc func donePicker() {
        
        yearOfGraduationTF.resignFirstResponder()
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}
