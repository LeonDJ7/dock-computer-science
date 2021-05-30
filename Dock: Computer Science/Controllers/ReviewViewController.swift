

import UIKit
import Firebase

class ReviewViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var reviews = [CollegeReviews]()
    @IBOutlet weak var CSReviewTable: UITableView!
    @IBOutlet weak var collegeTitleLbl: UILabel!
    var collRef: CollectionReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CSReviewTable.delegate = self
        CSReviewTable.dataSource = self
        
        collegeTitleLbl.text = selectedCollege
        
        collRef = Firestore.firestore().collection("Colleges").document(selectedCollege).collection("Reviews")
        retrieveReviews()
    }
    
    func retrieveReviews() {
        collRef.getDocuments() { (querySnapshot, error) in
            
            if let error = error {
                print("Could not find document: \(error)")
                return
            } else {
                for document in querySnapshot!.documents {
                    let myData = document.data()
                    let timestamp = myData["Timestamp"] as! NSNumber
                    let poster = myData["Poster"] as! String
                    let review = myData["Review"] as! String
                    let postInfo = CollegeReviews(poster: poster, review: review, timePosted: timestamp)
                    self.reviews.append(postInfo)
                }
            }
            self.reviews.sort { Double(truncating: $0.timePosted) > Double(truncating: $1.timePosted) }
            self.CSReviewTable.reloadData()
        }
    }
        
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = CSReviewTable.dequeueReusableCell(withIdentifier: "reviewCell", for: indexPath) as! ReviewTableViewCell
        cell.postContent.text = reviews[indexPath.row].review
        cell.posterInfo.text = reviews[indexPath.row].poster
        let timePosted = reviews[indexPath.row].timePosted
        let postDate = Date(timeIntervalSince1970: TimeInterval(truncating: timePosted))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy  |  HH:mm:ss zzz"
        let strDate = dateFormatter.string(from: postDate)
        cell.postTime.text = strDate
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

}
