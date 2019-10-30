//
//  CoupleQuestionController.swift
//  Mohae
//
//  Created by 이주영 on 2019/10/29.
//  Copyright © 2019 권혁준. All rights reserved.
//

import UIKit
import SnapKit

class CoupleQuestionController: UIViewController {
    var coupleQuestionView: CoupleQuestionView?
    let nextViewDelegate = PeopleQuestionController()
    var data = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        coupleQuestionView = CoupleQuestionView()
        setView()
    }
    
    func setView() {
        if let coupleQuestion = coupleQuestionView {
            let surveyBoard = coupleQuestion.surveyScreen
            let questionLabel = coupleQuestion.questionLabel
            let yesButton = coupleQuestion.yesButton
            let noButton = coupleQuestion.noButton
            
            coupleQuestion.delegate = self
            if let board = surveyBoard, let question = questionLabel, let yesBtn = yesButton, let noBtn = noButton {
                view.addSubview(board)
                board.snp.makeConstraints { (make) in
                    make.centerX.equalTo(view.snp.centerX)
                    make.centerY.equalTo(view.snp.centerY)
                    make.width.equalTo(view.snp.width)
                    make.height.equalTo(view.snp.height)
                }
                
                question.snp.makeConstraints { (make) in
                    make.centerX.equalTo(board.snp.centerX)
                    make.centerY.equalTo(board.snp.centerY)
                }
                
                yesBtn.snp.makeConstraints { (make) in
                    make.top.equalTo(question.snp.bottom).offset(50)
                    make.centerX.equalTo(board.snp.centerX)
                }
                
                noBtn.snp.makeConstraints { (make) in
                    make.top.equalTo(yesBtn.snp.bottom).offset(20)
                    make.centerX.equalTo(board.snp.centerX)
                }
            }
        }
    }
    
    func changeView(insert: String) {
        self.data.append(insert)
        nextViewDelegate.reciveData(data: self.data)
        let peopleQuestionController = PeopleQuestionController()
        let navController = UINavigationController(rootViewController: peopleQuestionController)
        present(navController, animated: true, completion: nil)
    }
}

extension CoupleQuestionController: CoupleQuestionButtonDelegate {
    func touchYes() {
        print("Yes !!")
        changeView(insert: "Y")
    }
    
    func touchNo() {
        print("No...")
        changeView(insert: "N")
    }
}
