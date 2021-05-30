
import UIKit
import Firebase

class ForgotPasswordViewController: UIViewController {
    
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var sendResetBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sendResetBtn.layer.cornerRadius = sendResetBtn.layer.cornerRadius / 2
    }
    
    @IBAction func sendReset(_ sender: Any) {
        
        Auth.auth().sendPasswordReset(withEmail: (emailTF.text)!) { (error) in
            if error != nil {
                AlertController.showAlert(self, title: "Error", message: error!.localizedDescription)
            } else {
                AlertController.showAlert(self, title: "Success", message: "Check your email")
                self.emailTF.text = ""
            }
        }
    }
}
