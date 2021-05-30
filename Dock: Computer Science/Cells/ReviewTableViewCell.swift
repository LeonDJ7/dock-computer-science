//
//  CSReviewTableViewCell.swift
//  Dock: Computer Science
//
//  Created by Leon Djusberg on 5/26/18.
//  Copyright © 2018 Leon Djusberg. All rights reserved.
//

import UIKit

class ReviewTableViewCell: UITableViewCell {

    @IBOutlet weak var posterInfo: UILabel!
    @IBOutlet weak var postContent: UILabel!
    @IBOutlet weak var postTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
