//
//  ViewController.swift
//  Dock: Computer Science
//
//  Created by Leon Djusberg on 5/19/18.
//  Copyright © 2018 Leon Djusberg. All rights reserved.
//

import UIKit
import Firebase
import GoogleMobileAds

var selectedCollege = ""

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, GADBannerViewDelegate, GADInterstitialDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var homeTableView: UITableView!
    var interstitial: GADInterstitial!
    var colleges = [String]()
    var filteredColleges = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadDataFromFirestore()
        searchBar.delegate = self
        homeTableView.delegate = self
        homeTableView.dataSource = self
        let navBarImage = UIImageView(image: #imageLiteral(resourceName: "logo"))
        self.navigationItem.titleView = navBarImage
        setCustomBackImage()
        
        let textFieldInsideUISearchBar = searchBar.value(forKey: "searchField") as? UITextField
        let fontDescriptor = UIFontDescriptor(name: "Menlo-Regular", size: 17)
        textFieldInsideUISearchBar?.font = UIFont(descriptor: fontDescriptor, size: 17)
        
        
        bannerView.adUnitID = "ca-app-pub-2790005755690511/7353659880"
        bannerView.rootViewController = self
        let bannerRequest = GADRequest()
        bannerView.load(bannerRequest)
        bannerView.delegate = self
        
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-2790005755690511/3578066408")
        interstitial.delegate = self
        let interstitialRequest = GADRequest()
        interstitial.load(interstitialRequest)
        interstitial = createAndLoadInterstitial()
        
    }
    
    func createAndLoadInterstitial() -> GADInterstitial {
        let interstitial = GADInterstitial(adUnitID: "ca-app-pub-2790005755690511/3578066408")
        interstitial.delegate = self
        let interstitialRequest = GADRequest()
        interstitial.load(interstitialRequest)
        return interstitial
    }
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        interstitial = createAndLoadInterstitial()
        performSegue(withIdentifier: "toSelectedCollege", sender: self)
    }
    
    func setCustomBackImage() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    func loadDataFromFirestore() {
        let db = Firestore.firestore()
        db.collection("Colleges").getDocuments { (querySnapshot, err) in
            if let err = err
            {
                print("Error getting documents: \(err)")
            }
            else
            {
                for document in querySnapshot!.documents {
                    self.colleges.append(document.documentID)
                    self.filteredColleges = self.colleges
                    self.homeTableView.reloadData()
                }
            }
        }
        self.homeTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredColleges.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = homeTableView.dequeueReusableCell(withIdentifier: "dataCell", for: indexPath) as! SearchDataCell
        
        cell.collegNameLbl.text = filteredColleges[indexPath.row]
            
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCollege = filteredColleges[indexPath.row]
        
        let randomNumber = arc4random_uniform(3)
        
        if randomNumber == 0 {
            
            if interstitial.isReady {
                interstitial.present(fromRootViewController: self)
                print("interstitial ready")
            } else {
                performSegue(withIdentifier: "toSelectedCollege", sender: self)
                print("interstitial not ready")
            }
        } else {
            performSegue(withIdentifier: "toSelectedCollege", sender: self)
            print("random number not correct")
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        homeTableView.isHidden = false
        
        guard !searchText.isEmpty else {
            filteredColleges = colleges
            homeTableView.isHidden = true
            return
        }
        
        filteredColleges = colleges.filter({ (college) -> Bool in
            
            return college.lowercased().contains(searchText.lowercased())
        })
        homeTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}

