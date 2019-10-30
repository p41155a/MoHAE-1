//
//  CoupleQuestionView.swift
//  Mohae
//
//  Created by 이주영 on 2019/10/29.
//  Copyright © 2019 권혁준. All rights reserved.
//

import UIKit

protocol CoupleQuestionButtonDelegate {
    func touchYes()
    func touchNo()
}

class CoupleQuestionView: UIView {
    var delegate: CoupleQuestionButtonDelegate?
    var questionLabel: UILabel?
    var yesButton: UIButton?
    var noButton: UIButton?
    var surveyScreen: UIView?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configure() {
        questionLabel = UILabel()
        yesButton = UIButton(type: .system)
        noButton = UIButton(type: .system)
        surveyScreen = UIView()
        
        if let questionLabel = self.questionLabel {
            questionLabel.translatesAutoresizingMaskIntoConstraints = false
            questionLabel.text = "커플?"
        }
        
        if let yesBtn = yesButton {
            yesBtn.translatesAutoresizingMaskIntoConstraints = false
            yesBtn.setTitle("예", for: .normal)
            yesBtn.sizeToFit()
            yesBtn.addTarget(self, action: #selector(touchedYes), for: .touchUpInside)
        }
        
        if let noBtn = noButton {
            noBtn.translatesAutoresizingMaskIntoConstraints = false
            noBtn.setTitle("아니오", for: .normal)
            noBtn.sizeToFit()
            noBtn.addTarget(self, action: #selector(touchedNo), for: .touchUpInside)
        }
        
        if let screen = surveyScreen {
            screen.translatesAutoresizingMaskIntoConstraints = false
            screen.backgroundColor = .white
            if let yesBtn = yesButton, let noBtn = noButton, let question = questionLabel {
                screen.addSubview(question)
                screen.addSubview(yesBtn)
                screen.addSubview(noBtn)
            }
            
            self.addSubview(screen)
        }
    }
    
    @objc func touchedYes() {
        delegate?.touchYes()
    }
    
    @objc func touchedNo() {
        delegate?.touchNo()
    }
}
