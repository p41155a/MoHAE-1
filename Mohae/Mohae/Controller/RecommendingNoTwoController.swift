//
//  RecommendingNoTwoController.swift
//  Mohae
//
//  Created by 이주영 on 2019/11/05.
//  Copyright © 2019 권혁준. All rights reserved.
//

import UIKit
import Firebase
import SnapKit

class RecommendingNoTwoController: UIViewController {
    var ref: DatabaseReference!
    var dataForAnalysis = [DataForAnalysis]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        loadDB()
    }
    
    func loadDB() {
        ref = Database.database().reference().child("DataForAnalysis2")
        
        ref.observe(.childAdded) { (snapshot) in
            guard let dictionary = snapshot.value as? [String: AnyObject] else {
                return
            }
            
            self.dataForAnalysis.append(DataForAnalysis(dictionary: dictionary))
//            print("category data => \(self.dataForAnalysis[0].categoryValue)")
//            print("couple data => \(self.dataForAnalysis[0].coupleValue)")
//            print("happy data => \(self.dataForAnalysis[0].happy)")
//            print("calm data => \(self.dataForAnalysis[0].calm)")
//            print("sad data => \(self.dataForAnalysis[0].sad)")
//            print("exciting data => \(self.dataForAnalysis[0].exciting)")
//            print("oneToFive data => \(self.dataForAnalysis[0].oneToFive)")
//            print("sixToTen data => \(self.dataForAnalysis[0].sixToTen)")
//            print("free data => \(self.dataForAnalysis[0].free)")
//            print("moreThan10 data => \(self.dataForAnalysis[0].moreThanTen)")
//            print("oneToTwo data => \(self.dataForAnalysis[0].onetToTwo)")
//            print("threeToFive data => \(self.dataForAnalysis[0].threeToFive)")
//            print("moreThanSix data => \(self.dataForAnalysis[0].moreThanSix)")
//            print("emotional data => \(self.dataForAnalysis[0].emotional)")
//            print("outsider data => \(self.dataForAnalysis[0].outsider)")
//            print("sensory data => \(self.dataForAnalysis[0].sensory)")
//            print("am data => \(self.dataForAnalysis[0].am)")
//            print("evening data => \(self.dataForAnalysis[0].evening)")
//            print("launch data => \(self.dataForAnalysis[0].launch)")
//            print("night data => \(self.dataForAnalysis[0].night)")
//            print("pm data => \(self.dataForAnalysis[0].pm)")
//            print("cloudy data => \(self.dataForAnalysis[0].cloudy)")
//            print("rainy data => \(self.dataForAnalysis[0].rainy)")
//            print("snow data => \(self.dataForAnalysis[0].snow)")
//            print("sunny data => \(self.dataForAnalysis[0].sunny)")
        }
    }
}
