
import UIKit
import Firebase
class AdviceViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var advice = [CollegeAdvice]()

    var reviews = [CollegeReviews]()
    @IBOutlet weak var collegeTitleLbl: UILabel!
    @IBOutlet weak var adviceTable: UITableView!
    var docRef: CollectionReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        adviceTable.delegate = self
        adviceTable.dataSource = self
        
        collegeTitleLbl.text = selectedCollege
        
        docRef = Firestore.firestore().collection("Colleges").document(selectedCollege).collection("Advice")
        retrieveReviews()
    }
    
    func retrieveReviews() {
        docRef.getDocuments() { (querySnapshot, error) in
            
            if let error = error {
                print("Could not find document: \(error)")
                return
            } else {
                for document in querySnapshot!.documents {
                    let myData = document.data()
                    //ServerValue.timestamp()
                    let timestamp = myData["Timestamp"] as! NSNumber
                    let poster = myData["Poster"] as! String
                    let advice = myData["Advice"] as! String
                    let postInfo = CollegeAdvice(poster: poster, advice: advice, timePosted: timestamp)
                    self.advice.append(postInfo)
                }
            }
            self.advice.sort { Double(truncating: $0.timePosted) > Double(truncating: $1.timePosted) }
            self.adviceTable.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return advice.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = adviceTable.dequeueReusableCell(withIdentifier: "adviceCell", for: indexPath) as! AdviceTableViewCell
        cell.postContent.text = advice[indexPath.row].advice
        cell.posterInfo.text = advice[indexPath.row].poster
        let timePosted = advice[indexPath.row].timePosted
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
