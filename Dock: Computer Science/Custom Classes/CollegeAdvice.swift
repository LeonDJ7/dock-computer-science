//
//  college.swift
//  Dock: Computer Science
//
//  Created by Leon Djusberg on 5/19/18.
//  Copyright © 2018 Leon Djusberg. All rights reserved.
//

import Foundation

class CollegeAdvice {
    
    var poster = ""
    var advice = ""
    var timePosted = NSNumber()
    
    init(poster: String, advice: String, timePosted: NSNumber) {
        self.poster = poster
        self.advice = advice
        self.timePosted = timePosted
    }
}
