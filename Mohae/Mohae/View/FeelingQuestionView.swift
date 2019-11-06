//
//  FeelingQuestionView.swift
//  Mohae
//
//  Created by 이주영 on 2019/10/30.
//  Copyright © 2019 권혁준. All rights reserved.
//

import UIKit
// 5. 현재 기분은 어떤가요? -> 행복, 슬픔, 차분, 흥분 등 => 4 개 이상
protocol FeelingQuestionButtonDelegate {
    func touchHappy()
    func touchSad()
    func touchCalm()
    func touchExciting()
}

class FeelingQuestionView: UIView {
    var delegate: FeelingQuestionButtonDelegate?
    var surveyScreen: UIView?
    var questionLabel: UILabel?
    var happyButton: UIButton?
    var sadButton: UIButton?
    var calmButton: UIButton?
    var excitingButton: UIButton?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configure() {
        surveyScreen = UIView()
        questionLabel = UILabel()
        happyButton = UIButton(type: .system)
        sadButton = UIButton(type: .system)
        calmButton = UIButton(type: .system)
        excitingButton = UIButton(type: .system)
        
        if let questionLabel = self.questionLabel {
            questionLabel.translatesAutoresizingMaskIntoConstraints = false
            questionLabel.text = "현재 기분은 어떤가요?"
        }
        
        if let happyBtn = happyButton {
            happyBtn.translatesAutoresizingMaskIntoConstraints = false
            happyBtn.setTitle("행복", for: .normal)
            happyBtn.addTarget(self, action: #selector(touchedHappy), for: .touchUpInside)
        }
        
        if let sadBtn = sadButton {
            sadBtn.translatesAutoresizingMaskIntoConstraints = false
            sadBtn.setTitle("슬픔", for: .normal)
            sadBtn.addTarget(self, action: #selector(touchedSad), for: .touchUpInside)
        }
        
        if let calmBtn = calmButton {
            calmBtn.translatesAutoresizingMaskIntoConstraints = false
            calmBtn.setTitle("차분", for: .normal)
            calmBtn.addTarget(self, action: #selector(touchedCalm), for: .touchUpInside)
        }
        
        if let excitingBtn = excitingButton {
            excitingBtn.translatesAutoresizingMaskIntoConstraints = false
            excitingBtn.setTitle("흥분", for: .normal)
            excitingBtn.addTarget(self, action: #selector(touchedExciting), for: .touchUpInside)
        }
        
        if let screen = surveyScreen {
            screen.translatesAutoresizingMaskIntoConstraints = false
            screen.backgroundColor = .white
            
            if let happyBtn = happyButton, let sadBtn = sadButton, let calmBtn = calmButton, let excitingBtn = excitingButton, let questionLabel = self.questionLabel {
                screen.addSubview(happyBtn)
                screen.addSubview(sadBtn)
                screen.addSubview(calmBtn)
                screen.addSubview(excitingBtn)
                screen.addSubview(questionLabel)
            }
            
            self.addSubview(screen)
        }
    }
    
    @objc func touchedHappy() {
        delegate?.touchHappy()
    }
    
    @objc func touchedSad() {
        delegate?.touchSad()
    }
    
    @objc func touchedCalm() {
        delegate?.touchCalm()
    }
    
    @objc func touchedExciting() {
        delegate?.touchExciting()
    }
}

