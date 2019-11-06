//
//  AnalysisController.swift
//  Mohae
//
//  Created by MC975-107 on 06/10/2019.
//  Copyright © 2019 권혁준. All rights reserved.
//

import UIKit
import Firebase

class AnalysisController: UIViewController {
    
    //var delegate = AnalysisController()
    var data: [String] = []
    let logoImage = UIImageView()
    let logo = UIImage(named: "mohaeMain")
    var label = [UILabel(),UILabel(),UILabel()]
    var highData = ["외향","감각","사고"]
    var lowData = ["내향","직관","감정"]
    
    let sendButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("완료", for: .normal)
        btn.tintColor = .white
        btn.translatesAutoresizingMaskIntoConstraints = false
        //btn.addTarget(self, action: #selector(complete), for: .touchUpInside)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 로고 이미지
        self.logoImage.layer.borderWidth = 0
        view.addSubview(self.logoImage)
        self.logoImage.image = self.logo
        
        // 결과 프린트
        for i in 0 ... 2{
            let doubleData = Double(data[i]) ?? 0
            if(doubleData >= 50){
                data[i] = highData[i]
            } else if(doubleData < 50){
                data[i] = lowData[i]
            }
            label[i] = UILabel()
            label[i].translatesAutoresizingMaskIntoConstraints = false
            label[i].font = UIFont.systemFont(ofSize: 20)
            view.addSubview(label[i])
            label[i].text = "당신은 \(data[i]) 쪽에 가깝습니다"
            let attributedStr = NSMutableAttributedString(string: label[i].text!)
            attributedStr.addAttribute(.foregroundColor, value: UIColor.blue, range: (label[i].text! as NSString).range(of: "\(data[i])"))
            attributedStr.addAttribute(.foregroundColor, value: UIColor.lightGray, range: (label[i].text! as NSString).range(of: "당신은"))
             attributedStr.addAttribute(.foregroundColor, value: UIColor.lightGray, range: (label[i].text! as NSString).range(of: "쪽에 가깝습니다"))
            label[i].attributedText = attributedStr
            
            view.addSubview(sendButton)
            sendButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
            sendButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -20).isActive = true
        }
        
        view.backgroundColor = .white
        logoImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        label[0].centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        label[0].centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        label[1].centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        label[2].centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        logoImage.snp.makeConstraints { (make) in
            make.bottom.equalTo(label[0].snp.top).offset(-20)
            make.width.equalTo(view.frame.width-20)
            make.height.equalTo(view.frame.width/1.5)
        }
        
        label[1].snp.makeConstraints { (make) in
            make.top.equalTo(label[0].snp.bottom).offset(20)
        }
        
        label[2].snp.makeConstraints { (make) in
            make.top.equalTo(label[1].snp.bottom).offset(20)
        }
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "뒤로", style: .plain, target: self, action: #selector(goBack))
    }
    
    func reciveData(data: String) {
        self.data = data.components(separatedBy: [" "])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let surveyViewController = segue.destination as? SurveyViewController {
            surveyViewController.delegate = self
        }
    }
    
    /*
    @objc func complete() {
        let navController = UINavigationController(rootViewController: delegate) //네비게이션으로 analysiscontroller로 가자고 하는 화면
        present(navController, animated: true, completion: nil)
    }
    */
    
    @objc private func goBack() {
        dismiss(animated: true, completion: nil)
    }
}
