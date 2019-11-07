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
    
    var ref : DatabaseReference!
    var delegate = AnalysisController()
    var mainSurveys = [MainSurvey]()
    var count = 0
    var dropBoxData: String?
    var mainSurveyCell = MainSurveyCell()
    
    let collectionView: UICollectionView = {
        // 각 섹션에 대한 선택적 머리글 및 바닥 글보기를 사용하여 항목을 그리드로 구성하는 콘크리트 레이아웃 객체
      //https://developer.apple.com/documentation/uikit/uicollectionviewflowlayout
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        // 뷰의 자동 크기 조정 마스크가 제약 조건 기반 레이아웃 시스템의 제약 조건으로 변환되는지 여부를 나타내는 부울 값입니다.
        cv.translatesAutoresizingMaskIntoConstraints = false
        // 새로운 컬렉션 뷰 셀을 만드는 데 사용할 클래스를 등록하십시오.
        cv.register(MainSurveyCell.self, forCellWithReuseIdentifier: cellId)
        
        return cv
    }()
    
    // 타이틀뷰 설정
    let titleView: UIView = {
        /*
        let titleLabel = UILabel()
        titleLabel.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        titleLabel.text = "설문지"
        titleLabel.font = UIFont(name: "NanumSquareR", size:15)
        titleLabel.font = UIFont.boldSystemFont(ofSize: 22)
        titleLabel.textColor = UIColor(red:0.27, green:0.27, blue:0.27, alpha:1.0)
        */
        let titleLabel = UILabel()
        
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.textColor = UIColor.gray
        titleLabel.font = UIFont.boldSystemFont(ofSize: 22)
        titleLabel.text = "설문지"
        titleLabel.sizeToFit()
        titleLabel.textColor = UIColor.black
        
        let subtitleLabel = UILabel(frame: CGRect(x:0, y:24, width:0, height:0))
        subtitleLabel.backgroundColor = UIColor.clear
        subtitleLabel.textColor = UIColor.darkGray
        subtitleLabel.font = UIFont.systemFont(ofSize: 12)
        subtitleLabel.text = "추천을 위한 설문"
        subtitleLabel.sizeToFit()
        
        let titleView = UIView(frame: CGRect(x:0, y:0, width:max(titleLabel.frame.size.width, subtitleLabel.frame.size.width), height:50))
        titleView.addSubview(titleLabel)
        titleView.addSubview(subtitleLabel)
        return titleView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad start")
        
        setView()
        loadSurvey()
        
        print("viewDidLoad end")
    }
    
    func setView() {
        let sendButton: UIButton = {
            let btn = UIButton(type: .system)
            btn.setTitle("완료", for: .normal)
            btn.backgroundColor = .systemPink
            btn.tintColor = .white
            btn.translatesAutoresizingMaskIntoConstraints = false
            btn.addTarget(self, action: #selector(complete), for: .touchUpInside)
            return btn
        }()
        
        view.addSubview(collectionView)
        view.addSubview(sendButton)
        
        let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.minimumLineSpacing = 2
        
        collectionView.backgroundColor = .lightGray
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo:  sendButton.topAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        sendButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        sendButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -20).isActive = true
        
        sendButton.snp.makeConstraints { (make) in
            make.width.equalTo(view.frame.width)
            make.height.equalTo(40)
        }
        
        navigationController?.navigationBar.barTintColor = UIColor.systemTeal
        navigationItem.titleView = titleView
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "뒤로", style: .plain, target: self, action: #selector(goBack))
    }
    
    /* ---------- 설문 데이터베이스 로드 ----------*/
    func loadSurvey() {
        print("start load DB")
        //FIRDatabaseReference 가져오기
        self.mainSurveys.removeAll()
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
    
    /*  --------- 완료 버튼 후 계산, 이동 --------- */
    @objc func complete() {
        var active: Double = 0 // 외향 .vs 내향
        var artistic: Double = 0 // 감각 .vs 외향
        var experience: Double = 0 // 학습형 .vs 경험형
        for i in 0 ... 38{
            let mainSurvey = mainSurveys[i]
            if(mainSurvey.type == 1)
                { active += Double(mainSurvey.value ?? 0) }
            else if(mainSurvey.type == 2)
                { artistic += Double(mainSurvey.value ?? 0) }
            else if(mainSurvey.type == 3)
                { experience += Double(mainSurvey.value ?? 0) }
            else if(mainSurvey.type == 4){
                if(mainSurvey.value == 1){ active += 5.0 }
                if(mainSurvey.value == 2){ active += 4.0 }
                if(mainSurvey.value == 3){ active += 3.0 }
                if(mainSurvey.value == 4){ active += 2.0 }
                if(mainSurvey.value == 5){ active += 1.0 }
            }
            else if(mainSurvey.type == 5){
                if(mainSurvey.value == 1){ artistic += 5.0 }
                if(mainSurvey.value == 2){ artistic += 4.0 }
                if(mainSurvey.value == 3){ artistic += 3.0 }
                if(mainSurvey.value == 4){ artistic += 2.0 }
                if(mainSurvey.value == 5){ artistic += 1.0 }
            }
            else if(mainSurvey.type == 6){
                if(mainSurvey.value == 1){ experience += 5.0 }
                if(mainSurvey.value == 2){ experience += 4.0 }
                if(mainSurvey.value == 3){ experience += 3.0 }
                if(mainSurvey.value == 4){ experience += 2.0 }
                if(mainSurvey.value == 5){ experience += 1.0 }
            }
        }
        active = active*1.5
        artistic = artistic*1.5
        experience = experience*1.5
        
        let result = "\(active) \(artistic) \(experience)"
        delegate.reciveData(data: String(result)) // analysiscontroller에 값 전달
        let navController = UINavigationController(rootViewController: delegate) //네비게이션으로 analysiscontroller로 가자고 하는 화면
        present(navController, animated: true, completion: nil)
        
        self.ref = Database.database().reference()
        for i in 1 ... 39 {
            let itemsRef = self.ref.child("surveys").child("mainSurvey").child("question"+"\(i)")
            let childUpdate = ["value": 0]
            itemsRef.updateChildValues(childUpdate)
        }
    }
}

extension SurveyViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 110)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        print("collectionView value count = > \(self.mainSurveys.count)")
 
        return self.mainSurveys.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MainSurveyCell
        let mainSurvey = mainSurveys[indexPath.item]
        cell.backgroundColor = .white
        cell.textView.text = mainSurvey.question
        cell.layer.borderColor = UIColor.gray.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 8
        
        cell.textView.snp.makeConstraints { (make) in
            make.left.equalTo(cell.snp.left).offset(8)
            make.right.equalTo(cell.snp.right).offset(-8)
        }
        
        // 색 변환 소스
        if(mainSurvey.value == 1){
            cell.button[0].backgroundColor = .gray
            for i in 1 ... 4 {
                cell.button[i].backgroundColor = .white
            }
            // 색변환 후 셀 위치 조정
            self.collectionView.scrollToItem(at: indexPath as IndexPath, at: .top, animated: true)
        }
        else if(mainSurvey.value == 2){
            cell.button[0].backgroundColor = .white
            cell.button[1].backgroundColor = .gray
            for i in 2 ... 4 {
                cell.button[i].backgroundColor = .white
            }
            // 색변환 후 셀 위치 조정
            self.collectionView.scrollToItem(at: indexPath as IndexPath, at: .top, animated: true)
        }
        else if(mainSurvey.value == 3){
            for i in 0 ... 1 {
                cell.button[i].backgroundColor = .white
            }
            cell.button[2].backgroundColor = .gray
            for i in 3 ... 4 {
                cell.button[i].backgroundColor = .white
            }
            // 색변환 후 셀 위치 조정
            self.collectionView.scrollToItem(at: indexPath as IndexPath, at: .top, animated: true)
        }
        else if(mainSurvey.value == 4){
            for i in 0 ... 2 {
                cell.button[i].backgroundColor = .white
            }
            cell.button[3].backgroundColor = .gray
            cell.button[4].backgroundColor = .white
            // 색변환 후 셀 위치 조정
            self.collectionView.scrollToItem(at: indexPath as IndexPath, at: .top, animated: true)
        }
        else if(mainSurvey.value == 5){
            for i in 0 ... 3 {
                cell.button[i].backgroundColor = .white
            }
            cell.button[4].backgroundColor = .gray
            // 색변환 후 셀 위치 조정
            self.collectionView.scrollToItem(at: indexPath as IndexPath, at: .top, animated: true)
        }
        else if(mainSurvey.value == 0){
            for i in 0 ... 4 {
                cell.button[i].backgroundColor = .white
            }
        }
        
        let cell_width = cell.frame.width // 넓이를 정해주기 위한 셀 크기 계산
        
        // 제약조건 소스
        for i in 0 ... 4 {
            cell.button[i].snp.makeConstraints { (make) in
                make.top.equalTo(cell.textView.snp.bottom).offset(1)
                make.width.equalTo(cell_width/5-1)
                make.height.equalTo(40)
            }
            cell.button[i].tag = mainSurvey.id!
        }
        cell.button[0].addTarget(self, action: #selector(clickButton1), for: .touchUpInside)
        cell.button[1].addTarget(self, action: #selector(clickButton2), for: .touchUpInside)
        cell.button[2].addTarget(self, action: #selector(clickButton3), for: .touchUpInside)
        cell.button[3].addTarget(self, action: #selector(clickButton4), for: .touchUpInside)
        cell.button[4].addTarget(self, action: #selector(clickButton5), for: .touchUpInside)
        
        cell.button[0].snp.makeConstraints { (make) in
            make.left.equalTo(cell.snp.left).offset(2.5)
        }
        for i in 1 ... 3 {
            cell.button[i].snp.makeConstraints { (make) in
                make.left.equalTo(cell.button[i-1].snp.right).offset(0)
            }
        }
        cell.button[4].snp.makeConstraints { (make) in
            make.right.equalTo(cell.snp.right).offset(-2.5)
        }
        return cell
    }
    
    // 클릭 시 액션
    @objc func clickButton1(sender: UIButton) {
        self.ref = Database.database().reference()
        let itemsRef = self.ref.child("surveys").child("mainSurvey").child("question"+"\(sender.tag)")
        let childUpdate = ["value": 1]
        itemsRef.updateChildValues(childUpdate)
        count = 0
        loadSurvey()
        print("reload")
    }
    
    @objc func clickButton2(sender: UIButton) {
        self.ref = Database.database().reference()
        let itemsRef = self.ref.child("surveys").child("mainSurvey").child("question"+"\(sender.tag)")
        let childUpdate = ["value": 2]
        itemsRef.updateChildValues(childUpdate)
        count = 0
        loadSurvey()
        print("reload")
    }
    
    @objc func clickButton3(sender: UIButton) {
        self.ref = Database.database().reference()
        let itemsRef = self.ref.child("surveys").child("mainSurvey").child("question"+"\(sender.tag)")
        let childUpdate = ["value": 3]
        itemsRef.updateChildValues(childUpdate)
        count = 0
        loadSurvey()
        print("reload")
    }
    
    @objc func clickButton4(sender: UIButton) {
        self.ref = Database.database().reference()
        let itemsRef = self.ref.child("surveys").child("mainSurvey").child("question"+"\(sender.tag)")
        let childUpdate = ["value": 4]
        itemsRef.updateChildValues(childUpdate)
        count = 0
        loadSurvey()
        print("reload")
    }
    
    @objc func clickButton5(sender: UIButton) {
        self.ref = Database.database().reference()
        let itemsRef = self.ref.child("surveys").child("mainSurvey").child("question"+"\(sender.tag)")
        let childUpdate = ["value": 5]
        itemsRef.updateChildValues(childUpdate)
        count = 0
        loadSurvey()
        print("reload")
    }
}
