//
//  SubSurveyCell.swift
//  Mohae
//
//  Created by 이주영 on 28/08/2019.
//  Copyright © 2019 권혁준. All rights reserved.
//

import UIKit
import SimpleCheckbox

class SubSurveyCell: UITableViewCell {
    
    let checkBox: Checkbox = {
        let checkBox = Checkbox(frame: CGRect(x: 30, y: 80, width: 25, height: 25))
        checkBox.tintColor = .black
        checkBox.borderStyle = .square
        checkBox.checkmarkStyle = .tick
        checkBox.uncheckedBorderColor = .lightGray
        checkBox.borderWidth = 1
        checkBox.valueChanged = { (value) in
            print("value change: \(value)")
        }
        checkBox.translatesAutoresizingMaskIntoConstraints = false
        
        return checkBox
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        addSubview(checkBox)
        
        checkBox.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8).isActive = true
        checkBox.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        checkBox.widthAnchor.constraint(equalToConstant: 25).isActive = true
        checkBox.heightAnchor.constraint(equalToConstant: 25).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
