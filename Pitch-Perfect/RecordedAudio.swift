//
//  RecordedAudio.swift
//  Pitch-Perfect
//
//  Created by Vipin Aggarwal on 04/10/15.
//  Copyright © 2015 Vipin Aggarwal. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject {
    
    var filePathURL: NSURL!
    var title: String!
    
    
    init(withFilePathUrl url: NSURL, fileName name: String) {
        filePathURL = url
        title = name
    }
}
