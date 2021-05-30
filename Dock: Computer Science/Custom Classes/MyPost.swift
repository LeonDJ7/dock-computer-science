//
//  File.swift
//  Dock: Computer Science
//
//  Created by Leon Djusberg on 7/7/18.
//  Copyright © 2018 Leon Djusberg. All rights reserved.
//

import Foundation

class MyPost {
    
    var postCollege = ""
    var postType = ""
    var postContent = ""
    var postTime = NSNumber()
    var postKey = ""
    
    init(postCollege: String, postType: String, postContent: String, postTime: NSNumber, postKey: String) {
        self.postCollege = postCollege
        self.postType = postType
        self.postContent = postContent
        self.postTime = postTime
        self.postKey = postKey
    }
}
