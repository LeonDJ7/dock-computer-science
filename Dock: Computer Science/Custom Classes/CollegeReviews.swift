//
//  File.swift
//  Dock: Computer Science
//
//  Created by Leon Djusberg on 6/1/18.
//  Copyright © 2018 Leon Djusberg. All rights reserved.
//

import Foundation

class CollegeReviews {
    
    var poster = ""
    var review = ""
    var timePosted = NSNumber()
    
    init(poster: String, review: String, timePosted: NSNumber) {
        self.poster = poster
        self.review = review
        self.timePosted = timePosted
    }
}
