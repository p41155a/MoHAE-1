//
//  AgreeViewController.swift
//  Mohae
//
//  Created by 이주영 on 2019/11/07.
//  Copyright © 2019 권혁준. All rights reserved.
//

import UIKit
import SnapKit

class AgreeViewController: UIViewController {
    var search2: String?
    
    let resultLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        
        return lb
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        resultLabel.text = search2
        
        view.addSubview(resultLabel)
        
        resultLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(view.snp.centerX)
            make.centerY.equalTo(view.snp.centerY)
        }
    }
}
