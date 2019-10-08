//
//  mainSurveyCell.swift
//  Mohae
//
//  Created by MC975-107 on 06/10/2019.
//  Copyright © 2019 권혁준. All rights reserved.
//

import UIKit

class MainSurveyCell: UICollectionViewCell {
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.font = UIFont.systemFont(ofSize: 20)
        tv.backgroundColor = .red
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
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
}
