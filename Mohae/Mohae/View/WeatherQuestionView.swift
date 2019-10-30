//
//  WeatherQuestionView.swift
//  Mohae
//
//  Created by 이주영 on 2019/10/30.
//  Copyright © 2019 권혁준. All rights reserved.
//

import UIKit
// 4. 현재 날씨는 어떤가요? -> 맑음, 흐림, 비, 눈, 자연재해 => 5 개
protocol WeatherQuestionButtonDelegate {
    func touchSunny()
    func touchCloudy()
    func touchRain()
    func touchSnow()
    func touchDisaster()
}

class WeatherQuestionView: UIView {
    var delegate: WeatherQuestionButtonDelegate?
    var surveyScreen: UIView?
    var questionLabel: UILabel?
    var sunnyButton: UIButton?
    var cloudyButton: UIButton?
    var rainButton: UIButton?
    var snowButton: UIButton?
    var disasterButton: UIButton?
    
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
        sunnyButton = UIButton(type: .system)
        cloudyButton = UIButton(type: .system)
        rainButton = UIButton(type: .system)
        snowButton = UIButton(type: .system)
        disasterButton = UIButton(type: .system)
        
        if let questionLabel = self.questionLabel {
            questionLabel.translatesAutoresizingMaskIntoConstraints = false
            questionLabel.text = "현재 날씨는 어떤가요?"
        }
        
        if let sunnyBtn = sunnyButton {
            sunnyBtn.translatesAutoresizingMaskIntoConstraints = false
            sunnyBtn.setTitle("맑음", for: .normal)
            sunnyBtn.addTarget(self, action: #selector(touchedSunny), for: .touchUpInside)
        }
        
        if let cloudyBtn = cloudyButton {
            cloudyBtn.translatesAutoresizingMaskIntoConstraints = false
            cloudyBtn.setTitle("흐림", for: .normal)
            cloudyBtn.addTarget(self, action: #selector(touchedCloudy), for: .touchUpInside)
        }
        
        if let rainBtn = rainButton {
            rainBtn.translatesAutoresizingMaskIntoConstraints = false
            rainBtn.setTitle("비", for: .normal)
            rainBtn.addTarget(self, action: #selector(touchedRain), for: .touchUpInside)
        }
        
        if let snowBtn = snowButton {
            snowBtn.translatesAutoresizingMaskIntoConstraints = false
            snowBtn.setTitle("눈", for: .normal)
            snowBtn.addTarget(self, action: #selector(touchedSnow), for: .touchUpInside)
        }
        
        if let disasterBtn = disasterButton {
            disasterBtn.translatesAutoresizingMaskIntoConstraints = false
            disasterBtn.setTitle("자연재해", for: .normal)
            disasterBtn.addTarget(self, action: #selector(touchedDisaster), for: .touchUpInside)
        }
        
        if let screen = surveyScreen {
            screen.translatesAutoresizingMaskIntoConstraints = false
            screen.backgroundColor = .white
            
            if let sunnyBtn = sunnyButton, let cloudyBtn = cloudyButton, let rainBtn = rainButton, let snowBtn = snowButton, let disasterBtn = disasterButton, let questionLabel = self.questionLabel {
                screen.addSubview(questionLabel)
                screen.addSubview(sunnyBtn)
                screen.addSubview(cloudyBtn)
                screen.addSubview(rainBtn)
                screen.addSubview(snowBtn)
                screen.addSubview(disasterBtn)
            }
            
            self.addSubview(screen)
        }
    }
    
    @objc func touchedSunny() {
        delegate?.touchSunny()
    }
    
    @objc func touchedCloudy() {
        delegate?.touchCloudy()
    }
    
    @objc func touchedRain() {
        delegate?.touchRain()
    }
    
    @objc func touchedSnow() {
        delegate?.touchSnow()
    }
    
    @objc func touchedDisaster() {
        delegate?.touchDisaster()
    }
}
