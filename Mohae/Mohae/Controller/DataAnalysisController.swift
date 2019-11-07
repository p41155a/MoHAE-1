//
//  DataAnalysisController.swift
//  Mohae
//
//  Created by 이주영 on 2019/10/31.
//  Copyright © 2019 권혁준. All rights reserved.
//

import UIKit
import SnapKit
import Firebase

class DataAnalysisController: UIViewController {
    var count = 0
    var ref: DatabaseReference!
    var userRef: DatabaseReference!
    var user: User?
    var userPersonality = [String: Int]()
    
    var categorys = [Category]()
    var couples = [Couple]()
    var feelings = [Feeling]()
    var money = [Money]()
    var numberOfPeople = [NumberOfPeople]()
    var personality = [Personality]()
    var time = [Time]()
    var weather = [Weather]()
    
    var data = [String]()
    var resultLabels = [UILabel]()
    var key = ["커플 : ", "인원 : ", "자금 : ", "날씨 : ", "기분 : ", "현재 시간 : "]
    var feelingQuestionController: FeelingQuestionController?
    var recommendingController: RecommendingController?
    var completedData = [String: String]()
    
    let formatter = DateFormatter()
    
    let guideLabel: UILabel = {
        let tl = UILabel()
        tl.translatesAutoresizingMaskIntoConstraints = false
        tl.text = "다음과 같이 선택하셨습니다."
        
        return tl
    }()
    
    let completeButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("완료", for: .normal)
        btn.addTarget(self, action: #selector(complete), for: .touchUpInside)
        
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "뒤로", style: .plain, target: self, action: #selector(goBack))
        navigationItem.title = "입력 확인"
        
        feelingQuestionController = FeelingQuestionController()
        recommendingController = RecommendingController()
        
        loadDB()
        loadUserInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setView()
        print("현재 데이터 상태 => \(self.data)")
    }
    
    @objc func goBack() {
        self.data[4] = ""
        self.data[5] = ""
        if let feelingQuestion = feelingQuestionController {
            feelingQuestion.data = self.data
            self.navigationController?.popViewController(animated: true)
            print("removed array status = > \(feelingQuestion.data)")
        }
    }
    
    var navBarHeight: CGFloat?
    
    func setView() {
        
        view.addSubview(guideLabel)
        view.addSubview(completeButton)
        for labelNumber in 0 ... 5 {
            resultLabels.append(UILabel())
            resultLabels[labelNumber].translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(resultLabels[labelNumber])
        }
        
        if let navigationBarHeight = navigationController?.navigationBar.frame.height {
            navBarHeight = UIApplication.shared.statusBarFrame.height + navigationBarHeight
        }
        
        guideLabel.snp.makeConstraints { (make) in
            if let navBarHeight = self.navBarHeight {
                make.top.equalTo(view.snp.top).offset(navBarHeight + 200)
            }
            make.centerX.equalTo(view.snp.centerX)
        }
        
        resultLabels[0].snp.makeConstraints { (make) in
            make.top.equalTo(guideLabel.snp.bottom).offset(50)
            make.centerX.equalTo(view.snp.centerX)
        }
        
        resultLabels[0].text = key[0] + data[0]
        
        for labelNumber in 1 ... 5 {
            resultLabels[labelNumber].snp.makeConstraints { (make) in
                make.top.equalTo(resultLabels[labelNumber - 1].snp.bottom).offset(30)
                make.centerX.equalTo(view.snp.centerX)
            }
            
            resultLabels[labelNumber].text = key[labelNumber] + data[labelNumber]
        }
        
        completeButton.snp.makeConstraints { (make) in
            make.top.equalTo(view.snp.bottom).offset(-70)
            make.centerX.equalTo(view.snp.centerX)
        }
    }
    
    func loadUserInfo() {
//        guard let uid = Auth.auth().currentUser?.uid else {
//            return
//        } //현재 로그인한 사용자의 고유 아이디
        
        userRef = Database.database().reference().child("users").child("1hVFUb3AatdyrUyP19P4iUJsWYX2").child("personality")
        
        userRef.observe(.value) { (snapshot) in
            guard let dictionary = snapshot.value as? [String: AnyObject] else {
                return
            }
            
            self.user = User(dictionary: dictionary)
        }
    }
    
    func loadDB() {
        print("satrt load DB")
        
        ref = Database.database().reference().child("DataForAnalysis3")
        ref.child("category").observe(.childAdded) { (snapshot) in
            guard let dictionary = snapshot.value as? [String: AnyObject] else {
                return
            }
            
            print(dictionary)
            self.categorys.append(Category(dictionary: dictionary))
        }

        ref.child("couple").observe(.childAdded) { (snapshot) in
            guard let dictionary = snapshot.value as? [String: AnyObject] else {
                return
            }
            print(dictionary)
            self.couples.append(Couple(dictionary: dictionary))
        }

        ref.child("feeling").observe(.childAdded) { (snapshot) in
            guard let dictionary = snapshot.value as? [String: AnyObject] else {
                return
            }
            print(dictionary)
            self.feelings.append(Feeling(dictionary: dictionary))
        }

        ref.child("money").observe(.childAdded) { (snapshot) in
            guard let dictionary = snapshot.value as? [String: AnyObject] else {
                return
            }
            print(dictionary)
            self.money.append(Money(dictionary: dictionary))
        }

        ref.child("numberOfPeople").observe(.childAdded) { (snapshot) in
            guard let dictionary = snapshot.value as? [String: AnyObject] else {
                return
            }
            print(dictionary)
            self.numberOfPeople.append(NumberOfPeople(dictionary: dictionary))
        }

        ref.child("personality").observe(.childAdded) { (snapshot) in
            guard let dictionary = snapshot.value as? [String: AnyObject] else {
                return
            }
            print(dictionary)
            self.personality.append(Personality(dictionary: dictionary))
        }

        ref.child("time").observe(.childAdded) { (snapshot) in
            guard let dictionary = snapshot.value as? [String: AnyObject] else {
                return
            }
            print(dictionary)
            self.time.append(Time(dictionary: dictionary))
        }
        
        ref.child("weather").observe(.childAdded) { (snapshot) in
            guard let dictionary = snapshot.value as? [String: AnyObject] else {
                return
            }
            print(dictionary)
            self.weather.append(Weather(dictionary: dictionary))
        }
    }
    
    func setDBData() {
        if let recommending = recommendingController {
            recommending.categorys = self.categorys
            recommending.couples = self.couples
            recommending.feelings = self.feelings
            recommending.money = self.money
            recommending.numberOfPeople = self.numberOfPeople
            recommending.personality = self.personality
            recommending.time = self.time
            recommending.weather = self.weather
            
        }
    }
    
    func setNowData() {
        completedData = ["couple": data[0], "numberOfPeople": data[1], "money": data[2], "weather": data[3], "feeling": data[4], "time": data[5]]
        
        if let user = self.user {
            userPersonality = ["outsider": user.outsider!, "sensory": user.sensory!, "emotional": user.emotional!]
        }
       
        if let recommending = recommendingController {
            recommending.recivedData = completedData
            recommending.recivedPersonality = userPersonality
        }
    }
    
    @objc func complete() {
        print("complete")
        setDBData()
        setNowData()
        if let recommending = recommendingController {
            let navController = UINavigationController(rootViewController: recommending)
            present(navController, animated: true, completion: nil)
        }
    }
}
