//
//  Survey.swift
//  Mohae
//
//  Created by MC975-107 on 02/10/2019.
//  Copyright © 2019 권혁준. All rights reserved.
//

import Foundation
class MainSurvey: NSObject {
    var id: Int?
    var question: String?
    var type: Int?
    var value: Int?
    
    init(dictionary: [String: AnyObject]) {
        super.init()
        
        id = dictionary["id"] as? Int
        question = dictionary["question"] as? String
        type = dictionary["type"] as? Int
        value = dictionary["value"] as? Int
    }
}
