//
//  PeopleQuestionController.swift
//  Mohae
//
//  Created by 이주영 on 2019/10/30.
//  Copyright © 2019 권혁준. All rights reserved.
//

import UIKit
import SnapKit
// 2. 함께하는 인원은 몇 명인가요? -> 1 ~ 2명/ 3 ~ 5명/ 6명 이상 => 3 개
class PeopleQuestionController: UIViewController {
    var peopleQuestionView: PeopleQuestionView?
    var moneyQuestionController: MoneyQuestionController?
    var data = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "뒤로", style: .plain, target: self, action: #selector(goBack))
        peopleQuestionView = PeopleQuestionView()
        moneyQuestionController = MoneyQuestionController()
        setView()
    }
    
    @objc func goBack() {
        dismiss(animated: true, completion: nil)
    }
    
    func setView() {
        if let peopleQuestion = peopleQuestionView {
            let surveyBoard = peopleQuestion.surveyScreen
            let questionLabel = peopleQuestion.questionLabel
            let oneToTwoButton = peopleQuestion.oneToTwoButton
            let threeToFiveButton = peopleQuestion.threeToFiveButton
            let moreThanSixButton = peopleQuestion.moreThanSixButton
            
            peopleQuestion.delegate = self
            if let board = surveyBoard, let question = questionLabel, let oneToTwoBtn = oneToTwoButton, let threeToFiveBtn = threeToFiveButton, let moreThanSixBtn = moreThanSixButton {
                
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
                
                oneToTwoBtn.snp.makeConstraints { (make) in
                    make.top.equalTo(question.snp.bottom).offset(50)
                    make.centerX.equalTo(board.snp.centerX)
                }
                
                threeToFiveBtn.snp.makeConstraints { (make) in
                    make.top.equalTo(oneToTwoBtn.snp.bottom).offset(20)
                    make.centerX.equalTo(board.snp.centerX)
                }
                
                moreThanSixBtn.snp.makeConstraints { (make) in
                    make.top.equalTo(threeToFiveBtn.snp.bottom).offset(20)
                    make.centerX.equalTo(board.snp.centerX)
                }
            }
        }
    }
    
    func changeView(insert: String) {
        self.data.append(insert)
        if let moneyQuestion = moneyQuestionController {
            moneyQuestion.data = self.data
            let navConteroller = UINavigationController(rootViewController: moneyQuestion)
            present(navConteroller, animated: true, completion: nil)
        }
        //let moneyQuestionController = MoneyQuestionController()
    }
}

extension PeopleQuestionController: PeopleQuestionButtonDelegat {
    func touchOneToTwo() {
        print("one ~ two")
        changeView(insert: "1 ~ 2 명")
        print(self.data)
    }
    
    func touchThreeToFive() {
        print("three ~ five")
        changeView(insert: "3 ~ 5 명")
        print(self.data)
    }
    
    func touchMoreThanSix() {
        print("more than six")
        changeView(insert: "6 명 이상")
        print(self.data)
    }
}
