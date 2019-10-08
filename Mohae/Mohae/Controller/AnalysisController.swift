//
//  AnalysisController.swift
//  Mohae
//
//  Created by MC975-107 on 06/10/2019.
//  Copyright © 2019 권혁준. All rights reserved.
//

import UIKit

class AnalysisController: UIViewController {
    let text: UILabel = {
        let tv = UILabel()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.font = UIFont.systemFont(ofSize: 20)
        tv.backgroundColor = .red
        tv.textColor = .black
        
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(text)
        view.backgroundColor = .yellow
        text.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        text.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "뒤로", style: .plain, target: self, action: #selector(goBack))
    }
    
    func reciveData(data: String) {
        self.text.text = data
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
