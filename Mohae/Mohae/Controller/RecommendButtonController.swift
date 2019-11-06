//
//  RecommendButtonController.swift
//  Mohae
//
//  Created by 이주영 on 18/08/2019.
//  Copyright © 2019 이주영. All rights reserved.
//

import UIKit

class RecommendButtonController: UIViewController {
    
    lazy var recommendView: UIView = {
        let containerView = UIView()
        containerView.frame = CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y, width: self.view.frame.width, height: self.view.frame.height)
        containerView.backgroundColor = UIColor.white
        
        let recommendButton = UIButton(type: .system)
        recommendButton.setTitle("Recommend", for: .normal)
        recommendButton.translatesAutoresizingMaskIntoConstraints = false
        recommendButton.addTarget(self, action: #selector(setButton), for: .touchUpInside)
        containerView.addSubview(recommendButton)
        
        recommendButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        recommendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        
        return containerView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(recommendView)
    }

    @objc private func setButton() { // 현재 기분을 물어보는 질문지를 작성할 수 있는 화면으로 전환 되도록 작상헌다.
        let coupleQuestionController = CoupleQuestionController()
        let navController = UINavigationController(rootViewController: coupleQuestionController)
        present(navController, animated: true, completion: nil)
    }
}
