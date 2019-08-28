//
//  SubSurveyController.swift
//  Mohae
//
//  Created by 이주영 on 26/08/2019.
//  Copyright © 2019 이주영. All rights reserved.
//

import UIKit
import SimpleCheckbox

class SubSurveyController: UITableViewController {
    
    let cellId = "surveyCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "뒤로", style: .plain, target: self, action: #selector(goBack))
        tableView.register(SubSurveyCell.self, forCellReuseIdentifier: cellId)
        //self.view.addSubview(surveyView)
    }
    
    @objc func goBack() {
        dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! SubSurveyCell
        cell.textLabel?.text = "당신은 친구가 있습니까?"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
}
