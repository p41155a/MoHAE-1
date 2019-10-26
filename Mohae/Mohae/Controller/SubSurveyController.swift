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
import SnapKit

class SubSurveyController: UIViewController {
    let cellId = "surveyCell"
    
    var delegate = AnalysisController()
    var subSurveyCell = SubSurveyCell()
    var subSurveys = [SubSurvey]()
    var checkBox = [Checkbox]()
    var label = [UILabel]()
    var count = 0
    var dropBoxData: String?
    
    enum Wheather: String {
        case sunny = "맑음"
        case cloudy = "흐림"
        case rain = "비"
        case snow = "눈"
        case disasters = "자연재해"
    }
    
    //Data to be sent
    var dataToBeSent: [String] = ["", "", "", "", "", ""]
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(SubSurveyCell.self, forCellWithReuseIdentifier: cellId)
        
        return cv
    }()
    
    let sendButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("완료", for: .normal)
        btn.addTarget(self, action: #selector(complete), for: .touchUpInside)
        
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad start")
        
        view.backgroundColor = .white
        setView()
        loadSurvey()
        setupMoneyDropDown()
        
        print("viewDidLoad end")
    }
    
    func setView() {
        view.addSubview(collectionView)
        view.addSubview(sendButton)
        
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(view.snp.top)
            make.bottom.equalTo(sendButton.snp.top)
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
        }
        
        sendButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view.snp.centerX)
            make.bottom.equalTo(self.view.snp.bottom).offset(-20)
        }
        
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
        delegate.reciveData(data: dataToBeSent)
        
        let navController = UINavigationController(rootViewController: delegate)
        present(navController, animated: true, completion: nil)
    }
    
    let moneyDropButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("자금 선택", for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        
        return btn
    }()
    
    let moneyDropDown = DropDown()
    
    @objc func moneyDrop() {
        moneyDropDown.show()
    }
    
    func setupMoneyDropDown() {
        moneyDropDown.anchorView = moneyDropButton
        moneyDropDown.direction = .bottom
        moneyDropDown.dismissMode = .onTap
        moneyDropDown.bottomOffset = CGPoint(x: 0, y: moneyDropButton.bounds.height)
        moneyDropDown.dataSource = [
            "무료",
            "1 만 원 ~ 5 만 원",
            "6 만 원 ~ 10 만 원",
            "10 만 원 이상"
        ]
        
        moneyDropDown.selectionAction = { [weak self] (index, item) in
            self?.moneyDropButton.setTitle(item, for: .normal)
            self?.dataToBeSent[2] = item
            print(item)
        }
    }
    
    let personCount: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["1 ~ 2 명", "3 ~ 5 명", "6명 이상"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.selectedSegmentIndex = 0
        
        return sc
    }()
    
    @objc func changeSegValue() {
        switch personCount.selectedSegmentIndex {
          case 0:
              print("segment index : 0")
              self.dataToBeSent[1] = "1 ~ 2 명"

          case 1:
              print("segment index : 1")
              self.dataToBeSent[1] = "3 ~ 5 명"
          
          case 2:
              print("segment index : 2")
              self.dataToBeSent[1] = "6명 이상"
          
          default:
              break
        }
    }
}

extension SubSurveyController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("collectionView value count = > \(self.subSurveys.count)")
        
        return self.subSurveys.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("cellForItemAt")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SubSurveyCell
        let subSurvey = subSurveys[indexPath.item]
        cell.textView.text = subSurvey.question
        cell.backgroundColor = .yellow
        
        for _ in 0 ... 6 {
            checkBox.append(subSurveyCell.makeCheckBox())
            label.append(subSurveyCell.makeLabel())
        }
        
        if subSurvey.id == "id1" {
            print(subSurvey.id)
            for i in 5 ... 6 {
                cell.addSubview(checkBox[i])
                cell.addSubview(label[i])
            }
            
            checkBox[5].snp.makeConstraints { (make) in
                make.top.equalTo(cell.textView.snp.bottom).offset(8)
                make.left.equalTo(cell.textView.snp.left).offset(8)
                make.width.equalTo(25)
                make.height.equalTo(25)
            }
            
            checkBox[5].valueChanged = { (isChecked) in
                if isChecked {
                    self.count = self.count + 1
                    self.checkBox[6].isChecked = false
                    self.dataToBeSent[0] = "예"
                } else {
                    self.count = self.count - 1
                }
                print("count => \(self.count)")
            }
            
            label[5].text = "예"
            label[5].snp.makeConstraints { (make) in
                make.left.equalTo(checkBox[5].snp.right).offset(5)
                make.centerY.equalTo(checkBox[5].snp.centerY)
            }
            
            checkBox[6].snp.makeConstraints { (make) in
                make.top.equalTo(cell.textView.snp.bottom).offset(8)
                make.left.equalTo(label[5].snp.right).offset(8)
                make.width.equalTo(25)
                make.height.equalTo(25)
            }
            checkBox[6].valueChanged = { (isChecked) in
                if isChecked {
                    self.count = self.count + 1
                    self.checkBox[5].isChecked = false
                    self.dataToBeSent[0] = "아니오"
                } else {
                    self.count = self.count - 1
                }
                print("count => \(self.count)")
            }
            
            label[6].text = "아니오"
            label[6].snp.makeConstraints { (make) in
                make.left.equalTo(checkBox[6].snp.right).offset(5)
                make.centerY.equalTo(checkBox[6].snp.centerY)
            }
            
        } else if subSurvey.id == "id2" {
            print(subSurvey.id)
            cell.addSubview(personCount)
            
            personCount.snp.makeConstraints { (make) in
                make.top.equalTo(cell.textView.snp.bottom).offset(8)
                make.left.equalTo(cell.snp.left).offset(8)
                make.right.equalTo(cell.snp.right).offset(-8)
            }
            
            personCount.addTarget(self, action: #selector(changeSegValue), for: .touchUpInside)
            
        } else if subSurvey.id == "id3" {
            print(subSurvey.id)
            cell.addSubview(moneyDropButton)
            moneyDropButton.addTarget(self, action: #selector(moneyDrop), for: .touchUpInside)
            moneyDropButton.snp.makeConstraints { (make) in
                make.top.equalTo(cell.textView.snp.bottom).offset(8)
                make.left.equalTo(cell.snp.left).offset(8)
            }
        } else if subSurvey.id == "id4" {
            print(subSurvey.id)
            
            for i in 0 ... 4 {
                cell.addSubview(checkBox[i])
                cell.addSubview(label[i])
            }
            
            checkBox[0].snp.makeConstraints { (make) in
                make.top.equalTo(cell.textView.snp.bottom).offset(8)
                make.left.equalTo(cell.textView.snp.left).offset(8)
                make.width.equalTo(25)
                make.height.equalTo(25)
            }
            checkBox[0].valueChanged = { (isChecked) in
                if isChecked {
                    self.count = self.count + 1
                    for i in 0 ... 4 {
                        if (i != 0) {
                            self.checkBox[i].isChecked = false
                        }
                    }
                    self.dataToBeSent[3] = Wheather.sunny.rawValue
                } else {
                    self.count = self.count - 1
                }
                print("count => \(self.count)")
            }
            
            label[0].text = "맑음"
            label[0].snp.makeConstraints { (make) in
                make.left.equalTo(checkBox[0].snp.right).offset(5)
                make.centerY.equalTo(checkBox[0].snp.centerY)
            }
            
            checkBox[1].snp.makeConstraints { (make) in
                make.top.equalTo(cell.textView.snp.bottom).offset(8)
                make.left.equalTo(label[0].snp.right).offset(8)
                make.width.equalTo(25)
                make.height.equalTo(25)
            }
            
            checkBox[1].valueChanged = { (isChecked) in
                if isChecked {
                    self.count = self.count + 1
                    for i in 0 ... 4 {
                        if (i != 1) {
                            self.checkBox[i].isChecked = false
                        }
                    }
                    self.dataToBeSent[3] = Wheather.cloudy.rawValue
                } else {
                    self.count = self.count - 1
                }
                print("count => \(self.count)")
            }
            
            label[1].text = "흐림"
            label[1].snp.makeConstraints { (make) in
                make.left.equalTo(checkBox[1].snp.right).offset(5)
                make.centerY.equalTo(checkBox[1].snp.centerY)
            }
            
            checkBox[2].snp.makeConstraints { (make) in
                make.top.equalTo(cell.textView.snp.bottom).offset(8)
                make.left.equalTo(label[1].snp.right).offset(8)
                make.width.equalTo(25)
                make.height.equalTo(25)
            }
            checkBox[2].valueChanged = { (isChecked) in
                if isChecked {
                    self.count = self.count + 1
                    for i in 0 ... 4 {
                        if (i != 2) {
                            self.checkBox[i].isChecked = false
                        }
                    }
                    self.dataToBeSent[3] = Wheather.rain.rawValue
                } else {
                    self.count = self.count - 1
                }
                print("count => \(self.count)")
            }
            
            label[2].text = "비"
            label[2].snp.makeConstraints { (make) in
                make.left.equalTo(checkBox[2].snp.right).offset(5)
                make.centerY.equalTo(checkBox[2].snp.centerY)
            }
            
            checkBox[3].snp.makeConstraints { (make) in
                make.top.equalTo(cell.textView.snp.bottom).offset(8)
                make.left.equalTo(label[2].snp.right).offset(8)
                make.width.equalTo(25)
                make.height.equalTo(25)
            }
            checkBox[3].valueChanged = { (isChecked) in
                if isChecked {
                    self.count = self.count + 1
                    for i in 0 ... 4 {
                        if (i != 3) {
                            self.checkBox[i].isChecked = false
                        }
                    }
                    self.dataToBeSent[3] = Wheather.snow.rawValue
                } else {
                    self.count = self.count - 1
                }
                print("count => \(self.count)")
            }
            
            label[3].text = "눈"
            label[3].snp.makeConstraints { (make) in
                make.left.equalTo(checkBox[3].snp.right).offset(5)
                make.centerY.equalTo(checkBox[3].snp.centerY)
            }
            
            checkBox[4].snp.makeConstraints { (make) in
                make.top.equalTo(cell.textView.snp.bottom).offset(8)
                make.left.equalTo(label[3].snp.right).offset(8)
                make.width.equalTo(25)
                make.height.equalTo(25)
            }
            checkBox[4].valueChanged = { (isChecked) in
                if isChecked {
                    self.count = self.count + 19
                    for i in 0 ... 4 {
                        if (i != 4) {
                            self.checkBox[i].isChecked = false
                        }
                    }
                    self.dataToBeSent[3] = Wheather.disasters.rawValue
                } else {
                    self.count = self.count - 1
                }
                print("count => \(self.count)")
            }
            
            label[4].text = "자연재해"
            label[4].snp.makeConstraints { (make) in
                make.left.equalTo(checkBox[4].snp.right).offset(5)
                make.centerY.equalTo(checkBox[4].snp.centerY)
            }
        } else if subSurvey.id == "id5" {
            print(subSurvey.id)
        }
        
        return cell
    }
}
