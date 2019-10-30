//
//  WeatherQuestionController.swift
//  Mohae
//
//  Created by 이주영 on 2019/10/30.
//  Copyright © 2019 권혁준. All rights reserved.
//

import UIKit
import SnapKit
// 4. 현재 날씨는 어떤가요? -> 맑음, 흐림, 비, 눈, 자연재해 => 5 개
class WeatherQuestionController: UIViewController {
    var weatherQuestionView: WeatherQuestionView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "뒤로", style: .plain, target: self, action: #selector(goBack))
        weatherQuestionView = WeatherQuestionView()
        setView()
    }
    
    @objc func goBack() {
        dismiss(animated: true, completion: nil)
    }
    
    func setView() {
        if let weatherQuestion = weatherQuestionView {
            let surveyBoard = weatherQuestion.surveyScreen
            let questionLabel = weatherQuestion.questionLabel
            let sunnyButton  = weatherQuestion.sunnyButton
            let cloudyButton = weatherQuestion.cloudyButton
            let rainButton = weatherQuestion.rainButton
            let snowButton = weatherQuestion.snowButton
            let disasterButton = weatherQuestion.disasterButton
            
            weatherQuestion.delegate = self
            
            if let board = surveyBoard, let question = questionLabel, let sunnyBtn = sunnyButton, let cloudyBtn = cloudyButton, let rainBtn = rainButton, let snowBtn = snowButton, let disasterBtn = disasterButton {
                view.addSubview(board)
                board.snp.makeConstraints { (make) in
                    make.centerX.equalTo(view.snp.centerX)
                    make.centerY.equalTo(view.snp.centerY)
                    make.width.equalTo(view.snp.width)
                    make.height.equalTo(view.snp.height)
                }
                
                question.snp.makeConstraints { (make) in
                    make.centerX.equalTo(view.snp.centerX)
                    make.centerY.equalTo(view.snp.centerY)
                }
                
                sunnyBtn.snp.makeConstraints { (make) in
                    make.top.equalTo(question.snp.bottom).offset(50)
                    make.centerX.equalTo(board.snp.centerX)
                }
                
                cloudyBtn.snp.makeConstraints { (make) in
                    make.top.equalTo(sunnyBtn.snp.bottom).offset(20)
                    make.centerX.equalTo(board.snp.centerX)
                }
                
                rainBtn.snp.makeConstraints { (make) in
                    make.top.equalTo(cloudyBtn.snp.bottom).offset(20)
                    make.centerX.equalTo(board.snp.centerX)
                }
                
                snowBtn.snp.makeConstraints { (make) in
                    make.top.equalTo(rainBtn.snp.bottom).offset(20)
                    make.centerX.equalTo(board.snp.centerX)
                }
                
                disasterBtn.snp.makeConstraints { (make) in
                    make.top.equalTo(snowBtn.snp.bottom).offset(20)
                    make.centerX.equalTo(board.snp.centerX)
                }
            }
        }
    }
}

extension WeatherQuestionController: WeatherQuestionButtonDelegate {
    func touchSunny() {
        print("sunny <<~ ^ㅡ^ ~>>")
        let feelingQuestionController = FeelingQuestionController()
        let navController = UINavigationController(rootViewController: feelingQuestionController)
        present(navController, animated: true, completion: nil)
    }
    
    func touchCloudy() {
        print("cloud -_-")
        let feelingQuestionController = FeelingQuestionController()
        let navController = UINavigationController(rootViewController: feelingQuestionController)
        present(navController, animated: true, completion: nil)
    }
    
    func touchRain() {
        print("rain ;ㅇ")
        let feelingQuestionController = FeelingQuestionController()
        let navController = UINavigationController(rootViewController: feelingQuestionController)
        present(navController, animated: true, completion: nil)
    }
    
    func touchSnow() {
        print("~~~ snow ~~~")
        let feelingQuestionController = FeelingQuestionController()
        let navController = UINavigationController(rootViewController: feelingQuestionController)
        present(navController, animated: true, completion: nil)
    }
    
    func touchDisaster() {
        print("OMG THIS IS DISASTER!!")
        let feelingQuestionController = FeelingQuestionController()
        let navController = UINavigationController(rootViewController: feelingQuestionController)
        present(navController, animated: true, completion: nil)
    }
}
