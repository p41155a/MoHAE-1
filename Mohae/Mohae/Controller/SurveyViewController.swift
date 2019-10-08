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
    var label = [UILabel]()
    var count = 0
    var dropBoxData: String?
    
    var mainSurveyCell = MainSurveyCell()
    
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
        
        collectionView.backgroundColor = .white
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
        let dbRef = Database.database().reference().child("surveys").child("mainSurvey")
        
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
        return CGSize(width: view.frame.width, height: 100)
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
        let MainSurvey = mainSurveys[indexPath.item]
        cell.textView.text = MainSurvey.question
        cell.backgroundColor = .yellow
        
        cell.addSubview(cell.checkSeg)
        
        //reason: 'Unable to activate constraint with anchors <NSLayoutYAxisAnchor:0x600001624e00 "UISegmentedControl:0x7fd34701e6f0.top"> and <NSLayoutYAxisAnchor:0x600001624d40 "UITextView:0x7fd346076200'새로운 사람을 만나는 것을 즐기나요?'.bottom"> because they have no common ancestor.  Does the constraint or its anchors reference items in different view hierarchies?  That's illegal.'
        cell.checkSeg.snp.makeConstraints { (make) in
            make.top.equalTo(cell.textView.snp.bottom).offset(8)
            make.left.equalTo(cell.snp.left).offset(8)
            make.right.equalTo(cell.snp.right).offset(-8)
        }
        
        return cell
    }
 
}
