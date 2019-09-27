//
//  TestDropBox.swift
//  Mohae
//
//  Created by 이주영 on 23/09/2019.
//  Copyright © 2019 이주영. All rights reserved.
//

import UIKit
import DropDown

class TestDropBox: UIViewController {
    let chooseArticleButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Test DropDown", for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(chooseArticle), for: .touchUpInside)
        
        return btn
    }()
    
    let chooseArticleDropDown = DropDown()
    
    @objc func chooseArticle() {
        chooseArticleDropDown.show()
    }
    
    func setupChooseArticleDropDown() {
        chooseArticleDropDown.anchorView = chooseArticleButton
        chooseArticleDropDown.direction = .any
        chooseArticleDropDown.dismissMode = .onTap
        chooseArticleDropDown.bottomOffset = CGPoint(x: 0, y: chooseArticleButton.bounds.height)
        chooseArticleDropDown.dataSource = [
            "iPhone SE | Black | 64G",
            "Samsung S7",
            "Huawei P8 Lite Smartphone 4G",
            "Asus Zenfone Max 4G",
            "Apple Watwh | Sport Edition"
        ]
        
        chooseArticleDropDown.selectionAction = { [weak self] (index, item) in
            self?.chooseArticleButton.setTitle(item, for: .normal)
        }
        
        /*
        chooseArticleDropDown.multiSelectionAction = { [weak self] (indices, items) in
            print("Muti selection action called with: \(items)")
            if items.isEmpty {
                self?.chooseArticleButton.setTitle("", for: .normal)
            }
        }
         */
    }
    
    override func viewDidLoad() {
        self.view.addSubview(chooseArticleButton)
        chooseArticleButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        chooseArticleButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        
        setupChooseArticleDropDown()
    }
}
