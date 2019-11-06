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
        loadUserData()
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
    
    func loadUserData() {
        ref = Database.database().reference().child("members")
        
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
            print("categorys added => \(String(describing: self.categorys[self.count].value))")
            self.count = self.count + 1
        }

        ref.child("couple").observe(.childAdded) { (snapshot) in
            guard let dictionary = snapshot.value as? [String: AnyObject] else {
                return
            }
            print(dictionary)
            self.couples.append(Couple(dictionary: dictionary))
            print("couples added => \(String(describing: self.couples[0].value))")
        }

        ref.child("feeling").observe(.childAdded) { (snapshot) in
            guard let dictionary = snapshot.value as? [String: AnyObject] else {
                return
            }
            print(dictionary)
            self.feelings.append(Feeling(dictionary: dictionary))
            print("feelings added => \(String(describing: self.feelings[0].happy))")
        }

        ref.child("money").observe(.childAdded) { (snapshot) in
            guard let dictionary = snapshot.value as? [String: AnyObject] else {
                return
            }
            print(dictionary)
            self.money.append(Money(dictionary: dictionary))
            print("money added => \(String(describing: self.money[0].free))")
        }

        ref.child("numberOfPeople").observe(.childAdded) { (snapshot) in
            guard let dictionary = snapshot.value as? [String: AnyObject] else {
                return
            }
            print(dictionary)
            self.numberOfPeople.append(NumberOfPeople(dictionary: dictionary))
            print("numberOfPeople added => \(String(describing: self.numberOfPeople[0].oneToTwo))")
        }

        ref.child("personality").observe(.childAdded) { (snapshot) in
            guard let dictionary = snapshot.value as? [String: AnyObject] else {
                return
            }
            print(dictionary)
            self.personality.append(Personality(dictionary: dictionary))
            print("personality added => \(String(describing: self.personality[0].outsider))")
        }

        ref.child("time").observe(.childAdded) { (snapshot) in
            guard let dictionary = snapshot.value as? [String: AnyObject] else {
                return
            }
            print(dictionary)
            self.time.append(Time(dictionary: dictionary))
            print("time added => \(String(describing: self.time[0].am))")
        }
        
        ref.child("weather").observe(.childAdded) { (snapshot) in
            guard let dictionary = snapshot.value as? [String: AnyObject] else {
                return
            }
            print(dictionary)
            self.weather.append(Weather(dictionary: dictionary))
            print("weather added => \(String(describing: self.weather[0].sunny))")
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
        
        if let recommending = recommendingController {
            recommending.recivedData = completedData
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
//var categorys = [Category]()
//var couples = [Couple]()
//var feelings = [Feeling]()
//var money = [Money]()
//var numberOfPeople = [NumberOfPeople]()
//var personality = [Personality]()
//var time = [Time]()
//var weather = [Weather]()
