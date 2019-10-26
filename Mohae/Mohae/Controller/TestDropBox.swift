//
//  TestDropBox.swift
//  Mohae
//
//  Created by 이주영 on 23/09/2019.
//  Copyright © 2019 이주영. All rights reserved.
//

import UIKit
import SnapKit

class TestDropBox: UIViewController {
    var buttons = [UIButton]()
    // 3. 사용할 돈은 얼마 정도 생각하고 계신가요? -> 무료, 1 ~ 5, 6 ~ 10, 10 이상 => 4 개
    lazy var question: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.text = "사용할 돈은 얼마 정도 생각하고 계신가요?"
        
        return tf
    }()
    
    func makeButtons() -> UIButton {
        let btn = UIButton(type: .roundedRect)
        btn.translatesAutoresizingMaskIntoConstraints = false
        
        return btn
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(question)
       
        
        question.snp.makeConstraints { (make) in
            make.centerX.equalTo(view.snp.centerX)
            make.centerY.equalTo(view.snp.centerY)
        }
        
        for i in 0 ... 3 {
            buttons.append(makeButtons())
             view.addSubview(buttons[i])
        }
        
        buttons[0].setTitle("무료", for: .normal)
        buttons[1].setTitle("1 ~ 5 명", for: .normal)
        buttons[2].setTitle("6 ~ 10 명", for: .normal)
        buttons[3].setTitle("10 명 이상", for: .normal)
        
        buttons[0].snp.makeConstraints { (make) in
            make.top.equalTo(question.snp.bottom).offset(50)
            make.centerX.equalTo(view.snp.centerX)
        }
        
        buttons[1].snp.makeConstraints { (make) in
            make.top.equalTo(buttons[0].snp.bottom)
            make.centerX.equalTo(view.snp.centerX)
        }
        
        buttons[2].snp.makeConstraints { (make) in
            make.top.equalTo(buttons[1].snp.bottom)
            make.centerX.equalTo(view.snp.centerX)
        }
        
        buttons[3].snp.makeConstraints { (make) in
            make.top.equalTo(buttons[2].snp.bottom)
            make.centerX.equalTo(view.snp.centerX)
        }
    }
}
