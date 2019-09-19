//
//  SubSurveyCell.swift
//  Mohae
//
//  Created by 이주영 on 28/08/2019.
//  Copyright © 2019 이주영. All rights reserved.
//

import UIKit
import SimpleCheckbox

var count = 0

class SubSurveyCell: UICollectionViewCell{
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.font = UIFont.systemFont(ofSize: 20)
        tv.backgroundColor = .red
        tv.textColor = .black
        tv.isEditable = false
        
        return tv
    }()
    
    let checkBox: Checkbox = {
        let checkBox = Checkbox(frame: CGRect(x: 30, y: 80, width: 25, height: 25))
        checkBox.tintColor = .black
        checkBox.borderStyle = .square
        checkBox.checkmarkStyle = .tick
        checkBox.uncheckedBorderColor = .lightGray
        checkBox.borderWidth = 1
        checkBox.translatesAutoresizingMaskIntoConstraints = false
        
        return checkBox
    }()
 
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(textView)
        addSubview(checkBox)
        
        textView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        textView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        textView.widthAnchor.constraint(equalToConstant: 400).isActive = true
        textView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        checkBox.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        checkBox.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8).isActive = true
        checkBox.widthAnchor.constraint(equalToConstant: 25).isActive = true
        checkBox.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
