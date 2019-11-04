//
//  AnalysisController.swift
//  Mohae
//
//  Created by MC975-107 on 06/10/2019.
//  Copyright © 2019 권혁준. All rights reserved.
//

import UIKit
import Firebase
import Charts

class AnalysisController: UIViewController {
    
    var data: [String] = []
    var label = [UILabel(),UILabel(),UILabel()]
    var highData = ["외향","감각","학습형"]
    var lowData = ["내향","직관","경험형"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        }
        view.backgroundColor = .white
        label[0].centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        label[0].centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        label[1].centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        label[2].centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        label[1].snp.makeConstraints { (make) in
            make.top.equalTo(label[0].snp.bottom).offset(1)
        }
        
        label[2].snp.makeConstraints { (make) in
            make.top.equalTo(label[1].snp.bottom).offset(1)
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
    
    @objc private func goBack() {
        dismiss(animated: true, completion: nil)
    }
}
