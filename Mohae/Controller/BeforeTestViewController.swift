//
//  BeforeTestViewController.swift
//  Mohae
//
//  Created by Doyun on 2019/11/05.
//  Copyright © 2019 권혁준. All rights reserved.
//

import UIKit

class BeforeTestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black
        // Do any additional setup after loading the view.
    }
    

    @objc func moveTest(_ sender: UIButton) {
        let next:SurveyViewController = SurveyViewController()
        
        self.present(next, animated: true, completion: nil)
    }
    
    let goSurveyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("테스트시작", for: .normal)
        button.addTarget(self, action: #selector(moveTest(_:)), for: .touchUpInside)
      button.translatesAutoresizingMaskIntoConstraints = false
        
      return button
    }()
    
//    func layOut() {
//        let guide = view.safeAreaLayoutGuide
//        view.addSubview(goSurveyButton)
//        goSurveyButton.topAnchor.constraint(equalTo: guide.topAnchor, constant: 120).isActive = true
//        goSurveyButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
//    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
