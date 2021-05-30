//
//  MyPostsTableViewCell.swift
//  Dock: Computer Science
//
//  Created by Leon Djusberg on 7/7/18.
//  Copyright © 2018 Leon Djusberg. All rights reserved.
//

import UIKit

class MyPostsTableViewCell: UITableViewCell {

    @IBOutlet weak var postCollege: UILabel!
    @IBOutlet weak var postType: UILabel!
    @IBOutlet weak var postContent: UILabel!
    @IBOutlet weak var postTimestamp: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
