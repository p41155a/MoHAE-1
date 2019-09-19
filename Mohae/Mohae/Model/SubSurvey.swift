//
//  SubSurvey.swift
//  Mohae
//
//  Created by 이주영 on 28/08/2019.
//  Copyright © 2019 권혁준. All rights reserved.
//

import Foundation

class SubSurvey: NSObject {
    var question: String?
    
    init(dictionary: [String: AnyObject]) {
        super.init()
        
        question = dictionary["question"] as? String
    }
}
