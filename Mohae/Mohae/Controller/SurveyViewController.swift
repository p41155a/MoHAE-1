//
//  SurveyViewController.swift
//  Mohae
//
//  Created by MC975-107 on 01/10/2019.
//  Copyright © 2019 권혁준. All rights reserved.
//

import UIKit
import Firebase
import SnapKit

let cellId = "surveyCell"

class SurveyViewController: UIViewController {
    
    var delegate = AnalysisController()
    var SurveyCell = MainSurveyCell()
    var mainSurveys = [MainSurvey]()
    var button = [UIButton]()
    var label = [UILabel]()
    var count = 0
    var dropBoxData: String?
    
    var mainSurveyCell = MainSurveyCell()
    
    let buttonArray = ["그렇지 않음","그렇지 않은 편","보통","그런 편","그렇다"]
    
    let collectionView: UICollectionView = {
        // 각 섹션에 대한 선택적 머리글 및 바닥 글보기를 사용하여 항목을 그리드로 구성하는 콘크리트 레이아웃 객체
        // https://developer.apple.com/documentation/uikit/uicollectionviewflowlayout
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        // 뷰의 자동 크기 조정 마스크가 제약 조건 기반 레이아웃 시스템의 제약 조건으로 변환되는지 여부를 나타내는 부울 값입니다.
        cv.translatesAutoresizingMaskIntoConstraints = false
        // 새로운 컬렉션 뷰 셀을 만드는 데 사용할 클래스를 등록하십시오.
        cv.register(MainSurveyCell.self, forCellWithReuseIdentifier: cellId)
        
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
        
        let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.minimumLineSpacing = 2
        
        collectionView.backgroundColor = .lightGray
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: sendButton.topAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        sendButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        sendButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -20).isActive = true
        
        navigationItem.title = "설문"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "뒤로", style: .plain, target: self, action: #selector(goBack))
    }
    
    func loadSurvey() {
        print("start load DB")
        //FIRDatabaseReference 가져오기
        let dbRef = Database.database().reference().child("surveys").child("mainSurvey")
        //Firebase DB의 변경사항을 관찰하고 있다가 데이터를 실시간으로 받아오는 observe메소드
        //childAdded: 이벤트 타입으로서 항목 목록을 검색하거나 항목 목록에 대한 추가를 수신 대기합니다.
        //snapshot: 하위 데이터를 포함하여 해당 위치의 모든 데이터를 포함
        dbRef.observe(.childAdded) { (snapshot) in
            guard let dictionary = snapshot.value as? [String: Any] else {
                return
            }
            self.mainSurveys.append(MainSurvey(dictionary: dictionary as [String : AnyObject]))
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                let indexPath = NSIndexPath(item: self.mainSurveys.count - 1, section: 0)
                self.collectionView.scrollToItem(at: indexPath as IndexPath, at: .top, animated: true)
            }
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
}

extension SurveyViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        print("numberOfItemsInSection start")
        print("collectionView value count = > \(self.mainSurveys.count)")
        print("numberOfItemsInSection end")
 
        return self.mainSurveys.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("cellForItemAt")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MainSurveyCell
        let mainSurvey = mainSurveys[indexPath.item]
        cell.backgroundColor = .white
        cell.textView.text = mainSurvey.question
        cell.addSubview(cell.checkSeg)
        cell.addSubview(cell.checkView)
        cell.layer.borderColor = UIColor.gray.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 8
        
        cell.textView.snp.makeConstraints { (make) in
            make.left.equalTo(cell.snp.left).offset(8)
            make.right.equalTo(cell.snp.right).offset(-8)
        }
        
        cell.checkSeg.snp.makeConstraints { (make) in
            make.top.equalTo(cell.textView.snp.bottom).offset(8)
            make.left.equalTo(cell.snp.left).offset(8)
            make.right.equalTo(cell.snp.right).offset(-8)
        }
        
        
        for i in 0 ... 4 {
            button.append(mainSurveyCell.makebutton())
            cell.addSubview(button[i])
            button[0].setTitle(buttonArray[i], for: .normal)
        }
        
        button[0].snp.makeConstraints { (make) in
            make.top.equalTo(cell.checkSeg.snp.bottom).offset(8)
            make.left.equalTo(cell.snp.left).offset(8)
            make.width.equalTo(25)
            make.height.equalTo(25)
        }
        button[0].addTarget(self, action: #selector(clickButton1), for: .touchUpInside)
        button[1].snp.makeConstraints { (make) in
            make.top.equalTo(cell.textView.snp.bottom).offset(8)
            make.left.equalTo(button[0].snp.right).offset(1)
            make.width.equalTo(25)
            make.height.equalTo(25)
        }
        button[2].snp.makeConstraints { (make) in
            make.top.equalTo(cell.textView.snp.bottom).offset(8)
            make.left.equalTo(button[1].snp.right).offset(1)
            make.width.equalTo(25)
            make.height.equalTo(25)
        }
        button[3].snp.makeConstraints { (make) in
            make.top.equalTo(cell.textView.snp.bottom).offset(8)
            make.left.equalTo(button[2].snp.right).offset(1)
            make.width.equalTo(25)
            make.height.equalTo(25)
        }
        button[4].snp.makeConstraints { (make) in
            make.top.equalTo(cell.textView.snp.bottom).offset(8)
            make.left.equalTo(button[3].snp.right).offset(1)
            make.width.equalTo(25)
            make.height.equalTo(25)
        }
        return cell
    }
    @objc func clickButton1(sender: UIButton) {
      print("클릭1")
    }
}
