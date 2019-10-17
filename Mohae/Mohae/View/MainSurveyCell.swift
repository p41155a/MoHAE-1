//
//  mainSurveyCell.swift
//  Mohae
//
//  Created by MC975-107 on 06/10/2019.
//  Copyright © 2019 권혁준. All rights reserved.
//

import UIKit

class MainSurveyCell: UICollectionViewCell {
    
    let checkView: UIView = {
        let cv = UIView()
        cv.translatesAutoresizingMaskIntoConstraints = false
        let buttonArray = ["그렇지 않음","그렇지 않은 편","보통","그런 편","그렇다"]
        let size = cv.frame.width / 5
        let cg_y = -size
        for buttonName in buttonArray{
            let checkbutton = UIButton(frame: CGRect(x: 0, y: cg_y + size, width: size, height: 50))
            checkbutton.setTitle(buttonName, for:. normal)
            checkbutton.tag = +1
            cv.addSubview(checkbutton)
        }
        return cv
    }()
    
    func makebutton() -> UIButton {
        let button = UIButton(type: .system)
        
        return button
    }
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.textColor = .black
        tv.isEditable = false
        
        return tv
    }()
    
    let checkSeg: UISegmentedControl = {
        let cs = UISegmentedControl(items: ["그렇지 않음", "그렇지 않은 편", "보통", "그런 편", "그렇다"])
        cs.translatesAutoresizingMaskIntoConstraints = false
        cs.selectedSegmentIndex = 0
        
        return cs
    }()
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(textView)
        
        textView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        textView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        textView.widthAnchor.constraint(equalToConstant: 400).isActive = true
        textView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
}
