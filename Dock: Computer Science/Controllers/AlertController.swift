//
//  File.swift
//  Dock: Computer Science
//
//  Created by Leon Djusberg on 6/14/18.
//  Copyright © 2018 Leon Djusberg. All rights reserved.
//

import UIKit

class AlertController: UIViewController {

    static func showAlert(_ inViewController: UIViewController, title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        inViewController.present(alert, animated: true, completion: nil)
    }
}
