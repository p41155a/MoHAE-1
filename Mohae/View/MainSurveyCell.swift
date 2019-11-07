//
//  mainSurveyCell.swift
//  Mohae
//
//  Created by Doyun on 06/10/2019.
//  Copyright © 2019 Doyun. All rights reserved.
//

import UIKit

class MainSurveyCell: UICollectionViewCell {
    
    var button = [UIButton(),UIButton(),UIButton(),UIButton(),UIButton()]
    let buttonArray = ["그렇지않음","그렇지않은편","보통","그런편","그렇다"]
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.textColor = .black
        tv.isEditable = false
        
        return tv
    }()
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(textView)
        
        
        for i in 0 ... 4 {
            button[i] = UIButton(type: .system)
            button[i].layer.borderColor = UIColor.gray.cgColor
            button[i].layer.borderWidth = 1
            button[i].layer.cornerRadius = 3
            button[i].tintColor = UIColor.darkGray
            addSubview(button[i])
            button[i].setTitle(buttonArray[i], for: .normal)
        }
        
        textView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        textView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        textView.widthAnchor.constraint(equalToConstant: 400).isActive = true
        textView.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
}
