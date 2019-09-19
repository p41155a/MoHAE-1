//
//  SubSurveyController.swift
//  Mohae
//
//  Created by 이주영 on 26/08/2019.
//  Copyright © 2019 이주영. All rights reserved.
//

import UIKit
import Firebase
import SimpleCheckbox
import DropDown

let cellId = "surveyCell"

class SubSurveyController: UIViewController {
    
    var delegate = AnalysisController()
    var subSurveys = [SubSurvey]()
    var score = 0
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(SubSurveyCell.self, forCellWithReuseIdentifier: cellId)
        
        return cv
    }()
    
    let sendButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("완료", for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(complete), for: .touchUpInside)
        
  
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad start")
        
        setView()
        loadSurvey()
        
        print("viewDidLoad end")
    }
    
    func setView() {
        view.addSubview(collectionView)
        view.addSubview(sendButton)
        
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        sendButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        sendButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -20).isActive = true
        
        navigationItem.title = "설문"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "뒤로", style: .plain, target: self, action: #selector(goBack))
    }
    
    func loadSurvey() {
        print("start load DB")
        let dbRef = Database.database().reference().child("surveys").child("subSurvey")
        
        dbRef.observe(.childAdded) { (snapshot) in
            guard let dictionary = snapshot.value as? [String: Any] else {
                return
            }
            
            self.subSurveys.append(SubSurvey(dictionary: dictionary as [String : AnyObject]))
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                let indexPath = NSIndexPath(item: self.subSurveys.count - 1, section: 0)
                self.collectionView.scrollToItem(at: indexPath as IndexPath, at: .top, animated: true)
            }
            print("appended value = > \(self.subSurveys[0].question)")
        }
        print("end load DB")
    }
    
    @objc func goBack() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func complete() {
        print(count)
        
        delegate.reciveData(data: String(count))
        
        let navController = UINavigationController(rootViewController: delegate)
        present(navController, animated: true, completion: nil)
    }
    
    /*
    let checkBoxCouple: Checkbox = {
        let checkBox = Checkbox(frame: CGRect(x: 30, y: 80, width: 25, height: 25))
        checkBox.tintColor = .black
        checkBox.borderStyle = .square
        checkBox.checkmarkStyle = .tick
        checkBox.uncheckedBorderColor = .lightGray
        checkBox.borderWidth = 1
        checkBox.translatesAutoresizingMaskIntoConstraints = false
        
        return checkBox
    }()
    */
}

extension SubSurveyController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("numberOfItemsInSection start")
        print("collectionView value count = > \(self.subSurveys.count)")
        print("numberOfItemsInSection end")
        
        return self.subSurveys.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("cellForItemAt")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SubSurveyCell
        let subSurvey = subSurveys[indexPath.item]
        cell.textView.text = subSurvey.question
        cell.backgroundColor = .yellow
        cell.checkBox.valueChanged = { (value) in
            print("value change: \(value)")
            if value == true {
                count = count + 1
            } else if value == false {
                count = count - 1
            }
            print(count)
        }
        
        return cell
    }
}
