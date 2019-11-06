//
//  RecommendingController.swift
//  Mohae
//
//  Created by 이주영 on 2019/11/04.
//  Copyright © 2019 권혁준. All rights reserved.
//

import UIKit
import Firebase
import SnapKit
//1.Amusement_park, 2.Aquarium, 3.Art_gallery, 4.Bakery, 5.Bar, 6.Beauty_Salon, 7.Beauty_shop
//8.Bicycle_shop, 9.Book_store, 10.Bowling, 11.Cafe, 12.Camping, 13.Clothes_store, 14.Club, 15.DVD
//16.Department, 17.Electric_store, 18.Floist, 19.Hotel, 20.Jewelry_store, 21.Library
//22.Movie, 23.Museum, 24.Music, 25.PC, 26.Park, 27.Pet_store, 28.Shoes_store, 29.Shopping
//30.Spa, 31.Sporte, 32.University, 33.Wine, 34. Yoga, 35.Zoo, 36.furniture_store
class RecommendingController: UIViewController {
    var ref: DatabaseReference!
    var recivedData = [String: String]() //사용자가 현재 답한 데이터들이 모두 들어갈 딕셔너리
    
    //DB에서 받아오는 데이터들이 들어가는 배열
    var categorys = [Category]() // value: string ""
    var couples = [Couple]() // value: Int 0 or 1 or 2
    var feelings = [Feeling]() // calm: Int, exciting: Int, happy: Int, sad: Int
    var money = [Money]() // 1 ~ 5: Int, 6 ~ 10: Int, free: Int, moreThan10: Int
    var numberOfPeople = [NumberOfPeople]() // 1 ~ 2: Int, 3 ~ 5: Int, moreThan6: Int
    var personality = [Personality]() // emotional: Int, outsider: Int, sensory: Int
    var time = [Time]() // am: Int, evening: Int, launch: Int, night: Int, pm: Int
    var weather = [Weather]() // cloudy: Int, rainy: Int, snow: Int, sunny: Int
    
    // 1.couple, 2.numberOfPeople, 3.money, 4.weather, 5.feeling, 6.time
    var recivedCouple: String?
    var recivedNumberOfPeople: String?
    var recivedMoney: String?
    var recivedWeather: String?
    var recivedFeeling: String?
    var recivedTime: String?
    
    // 사용자가 현재 답한 데이터들이 들어가는 변수, 배열
    var processedCoupleData: Int!
    var processedNumberOfPeopleData: [Int]!
    var processedMoneyData: [Int]!
    var processedWeatherData: [Int]!
    var processedFeelingData: [Int]!
    var processedTimeData: [Int]!
    
    // 로그인된 사용자의 성격 넣기
    var processedPersonalityData: [Int]?
    
    // 비교 결과가 들어갈 변수
    var resultCouple = [Couple]()
    var resultNumberOfPeople = [NumberOfPeople]()
    var resultMoney = [Money]()
    var resultWeather = [Weather]()
    var resultFeeling = [Feeling]()
    var resultTime = [Time]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        recivedCouple = recivedData["couple"]
        recivedNumberOfPeople = recivedData["numberOfPeople"]
        recivedMoney = recivedData["money"]
        recivedWeather = recivedData["weather"]
        recivedFeeling = recivedData["feeling"]
        recivedTime = recivedData["time"]
        
        print(recivedTime)
        setRecivedData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print(recivedData)
    }
    
    func setRecivedData() {
        if recivedCouple == "Y" {
            processedCoupleData = 0
        } else if recivedCouple == "N" {
            processedCoupleData = 1
        } else {
            processedCoupleData = 2
        }
        
        if recivedNumberOfPeople == "1 ~ 2 명" {
            processedNumberOfPeopleData = [1, 0, 0]
        } else if recivedNumberOfPeople == "3 ~ 5 명" {
            processedNumberOfPeopleData = [0, 1, 0]
        } else if recivedNumberOfPeople == "6 명 이상" {
            processedNumberOfPeopleData = [0, 0, 1]
        }
        
        if recivedMoney == "1 ~ 5 만 원" {
            processedMoneyData = [1, 0, 0, 0]
        } else if recivedMoney == "6 ~ 10 만 원" {
            processedMoneyData = [0, 1, 0, 0]
        } else if recivedMoney == "무료" {
            processedMoneyData = [0, 0, 1, 0]
        } else if recivedMoney == "10 만 원 이상" {
            processedMoneyData = [0, 0, 0, 1]
        }
        
        if recivedWeather == "흐림" {
            processedWeatherData = [1, 0, 0, 0]
        } else if recivedWeather == "비" {
            processedWeatherData = [0, 1, 0, 0]
        } else if recivedWeather == "눈" {
            processedWeatherData = [0, 0, 1, 0]
        } else if recivedWeather == "맑음" {
            processedWeatherData = [0, 0, 0, 1]
        }
        
        if recivedFeeling == "차분" {
            processedFeelingData = [1, 0, 0, 0]
        } else if recivedFeeling == "흥분" {
            processedFeelingData = [0, 1, 0, 0]
        } else if recivedFeeling == "행복" {
            processedFeelingData = [0, 0, 1, 0]
        } else if recivedFeeling == "슬픔" {
            processedFeelingData = [0, 0, 0, 1]
        }
        
        if recivedTime == "오전" {
            processedTimeData = [1, 0, 0, 0, 0]
        } else if recivedTime == "저녁" {
            processedTimeData = [0, 1, 0, 0, 0]
        } else if recivedTime == "점심" {
            processedTimeData = [0, 0, 1, 0, 0]
        } else if recivedTime == "밤" {
            processedTimeData = [0, 0, 0, 1, 0]
        } else if recivedTime == "오후" {
            processedTimeData = [0, 0, 0, 0, 1]
        }
    }
    
    func compare() {
        for i in 0 ... 35 {
            if processedCoupleData == couples[i].value {
                
            }
            
            if processedNumberOfPeopleData[0] == numberOfPeople[i].oneToTwo, processedNumberOfPeopleData[1] == numberOfPeople[i].threeToFive, processedNumberOfPeopleData[2] == numberOfPeople[i].moreThanSix {
                
            }
            
            if processedMoneyData[0] == money[i].oneToFive, processedMoneyData[1] == money[i].sixToTen, processedMoneyData[2] == money[i].free, processedMoneyData[3] == money[i].moreThanTen {
                
            }
            
            if processedWeatherData[0] == weather[i].cloudy, processedWeatherData[1] == weather[i].rainy, processedWeatherData[2] == weather[i].snow, processedWeatherData[3] == weather[i].sunny {
                
            }
            
            if processedFeelingData[0] == feelings[i].calm, processedFeelingData[1] == feelings[i].exciting, processedFeelingData[2] == feelings[i].happy, processedFeelingData[3] == feelings[i].sad {
                
            }
            
            if processedTimeData[0] == time[i].am, processedTimeData[1] == time[i].evening, processedTimeData[2] == time[i].launch, processedTimeData[3] == time[i].night, processedTimeData[4] == time[i].pm {
                
            }
        }

    }
}
// 1.couple, 2.numberOfPeople, 3.money, 4.weather, 5.feeling, 6.time

//- 시간 나누기
//
//09:00 AM ~ 12 : 00 AM (오전)
//
//12 : 00 AM ~ 14 : 00 PM (점심)
//
//14 : 00 PM ~ 17 : 30 PM (오후)
//
//17 : 30 PM ~ 4 : 00 AM (저녁 + 술)
//
//4 : 00 AM ~ 09 : 00 AM (잠)
