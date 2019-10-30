//
//  MoneyQuestionController.swift
//  Mohae
//
//  Created by 이주영 on 2019/10/30.
//  Copyright © 2019 권혁준. All rights reserved.
//

import UIKit
import SnapKit
// 3. 사용할 돈은 얼마 정도 생각하고 계신가요? -> 무료, 1 ~ 5, 6 ~ 10, 10 이상 => 4 개
class MoneyQuestionController: UIViewController {
    var moneyQuestionView: MoneyQuestionView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "뒤로", style: .plain, target: self, action: #selector(goBack))
        moneyQuestionView = MoneyQuestionView()
        setView()
    }
    
    @objc func goBack() {
        dismiss(animated: true, completion: nil)
    }
    
    func setView() {
        if let moneyQuestion = moneyQuestionView {
            let surveyBoard = moneyQuestion.surveyScreen
            let questionLabel = moneyQuestion.questionLabel
            let freeButton = moneyQuestion.freeButton
            let oneToFiveButton = moneyQuestion.oneToFiveButton
            let sixToTenButton = moneyQuestion.sixToTenButton
            let moreThanTenButton = moneyQuestion.moreThanTenButton
            
            moneyQuestion.delegate = self
            if let board = surveyBoard, let question = questionLabel, let freeBtn = freeButton, let oneToFiveBtn = oneToFiveButton, let sixToTenBtn = sixToTenButton, let moreThanTenBtn = moreThanTenButton {
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
                
                freeBtn.snp.makeConstraints { (make) in
                    make.top.equalTo(question.snp.bottom).offset(50)
                    make.centerX.equalTo(board.snp.centerX)
                }
                
                oneToFiveBtn.snp.makeConstraints { (make) in
                    make.top.equalTo(freeBtn.snp.bottom).offset(20)
                    make.centerX.equalTo(board.snp.centerX)
                }
                
                sixToTenBtn.snp.makeConstraints { (make) in
                    make.top.equalTo(oneToFiveBtn.snp.bottom).offset(20)
                    make.centerX.equalTo(board.snp.centerX)
                }
                
                moreThanTenBtn.snp.makeConstraints { (make) in
                    make.top.equalTo(sixToTenBtn.snp.bottom).offset(20)
                    make.centerX.equalTo(board.snp.centerX)
                }
            }
        }
    }
}

extension MoneyQuestionController: MoneyQuestionButtonDelegate {
    func touchFree() {
        print("Free!!")
        let weatherQuestionController = WeatherQuestionController()
        let navController = UINavigationController(rootViewController: weatherQuestionController)
        present(navController, animated: true, completion: nil)
    }
    
    func touchOneToFive() {
        print("1 ~ 5 만")
        let weatherQuestionController = WeatherQuestionController()
        let navController = UINavigationController(rootViewController: weatherQuestionController)
        present(navController, animated: true, completion: nil)
    }
    
    func touchSixToTen() {
        print("6 ~ 10 만")
        let weatherQuestionController = WeatherQuestionController()
        let navController = UINavigationController(rootViewController: weatherQuestionController)
        present(navController, animated: true, completion: nil)
    }
    
    func touchMoreThanTen() {
        print("10 만 이상")
        let weatherQuestionController = WeatherQuestionController()
        let navController = UINavigationController(rootViewController: weatherQuestionController)
        present(navController, animated: true, completion: nil)
    }
}
