//
//  User.swift
//  Mohae
//
//  Created by 이주영 on 20/08/2019.
//  Copyright © 2019 이주영. All rights reserved.
//

import Foundation

class User: NSObject {
    var name: String?
    var email: String?
    var outsider: Int?
    var sensory: Int?
    var emotional: Int?
    
    init(dictionary: [String: AnyObject]) {
        super.init()
        
        outsider = dictionary["outsider"] as? Int
        sensory = dictionary["sensory"] as? Int
        emotional = dictionary["emotional"] as? Int
    }
}
