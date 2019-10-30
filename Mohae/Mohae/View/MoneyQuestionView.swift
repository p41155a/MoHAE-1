//
//  MoneyQuestionView.swift
//  Mohae
//
//  Created by 이주영 on 2019/10/30.
//  Copyright © 2019 권혁준. All rights reserved.
//

import UIKit
// 3. 사용할 돈은 얼마 정도 생각하고 계신가요? -> 무료, 1 ~ 5, 6 ~ 10, 10 이상 => 4 개
protocol MoneyQuestionButtonDelegate {
    func touchFree()
    func touchOneToFive()
    func touchSixToTen()
    func touchMoreThanTen()
}

class MoneyQuestionView: UIView {
    var delegate: MoneyQuestionButtonDelegate?
    var surveyScreen: UIView?
    var questionLabel: UILabel?
    var freeButton: UIButton?
    var oneToFiveButton: UIButton?
    var sixToTenButton: UIButton?
    var moreThanTenButton: UIButton?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    override required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configure() {
        surveyScreen = UIView()
        questionLabel = UILabel()
        freeButton = UIButton(type: .system)
        oneToFiveButton = UIButton(type: .system)
        sixToTenButton = UIButton(type: .system)
        moreThanTenButton = UIButton(type: .system)
        
        if let questionLabel = self.questionLabel {
            questionLabel.translatesAutoresizingMaskIntoConstraints = false
            questionLabel.text = "사용할 돈은 얼마 정도 생각하고 계신가요?"
        }
        
        if let freeBtn = freeButton {
            freeBtn.translatesAutoresizingMaskIntoConstraints = false
            freeBtn.sizeToFit()
            freeBtn.setTitle("무료", for: .normal)
            freeBtn.addTarget(self, action: #selector(touchedFree), for: .touchUpInside)
        }
        
        if let oneToFiveBtn = oneToFiveButton {
            oneToFiveBtn.translatesAutoresizingMaskIntoConstraints = false
            oneToFiveBtn.sizeToFit()
            oneToFiveBtn.setTitle("1 만 원 ~ 5 만 원", for: .normal)
            oneToFiveBtn.addTarget(self, action: #selector(touchedOneToFive), for: .touchUpInside)
        }
        
        if let sixToTenBtn = sixToTenButton {
            sixToTenBtn.translatesAutoresizingMaskIntoConstraints = false
            sixToTenBtn.sizeToFit()
            sixToTenBtn.setTitle("6 만 원 ~ 10 만 원", for: .normal)
            sixToTenBtn.addTarget(self, action: #selector(touchedSixToTen), for: .touchUpInside)
        }
        
        if let moreThanTenBtn = moreThanTenButton {
            moreThanTenBtn.translatesAutoresizingMaskIntoConstraints = false
            moreThanTenBtn.sizeToFit()
            moreThanTenBtn.setTitle("10 만 원 이상", for: .normal)
            moreThanTenBtn.addTarget(self, action: #selector(touchedMoreThanTen), for: .touchUpInside)
        }
        
        if let screen = surveyScreen {
            screen.translatesAutoresizingMaskIntoConstraints = false
            screen.backgroundColor = .white
            
            if let freeBtn = freeButton, let oneToFiveBtn = oneToFiveButton, let sixToTenBtn = sixToTenButton, let moreThanTenBtn = moreThanTenButton, let questionLabel = self.questionLabel {
                
                screen.addSubview(questionLabel)
                screen.addSubview(freeBtn)
                screen.addSubview(oneToFiveBtn)
                screen.addSubview(sixToTenBtn)
                screen.addSubview(moreThanTenBtn)
            }
            
            self.addSubview(screen)
        }
    }
    
    @objc func touchedFree() {
        delegate?.touchFree()
    }
    
    @objc func touchedOneToFive() {
        delegate?.touchOneToFive()
    }
    
    @objc func touchedSixToTen() {
        delegate?.touchSixToTen()
    }
    
    @objc func touchedMoreThanTen() {
        delegate?.touchMoreThanTen()
    }
}
