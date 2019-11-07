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
    var agreeViewController: AgreeViewController?
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
    var recivedPersonality: [String: Int]?
    
    // 사용자가 현재 답한 데이터들이 들어가는 변수, 배열
    var processedCoupleData: Int!
    var processedTimeData: [Int]!
    
    // 로그인된 사용자의 성격 넣기
    // 고유 ID를 사용해서 personality 값 가저오기
    
    // 비교 결과가 들어갈 변수
    //1.Amusement_park, 2.Aquarium, 3.Art_gallery, 4.Bakery, 5.Bar, 6.Beauty_Salon, 7.Beauty_shop
    //8.Bicycle_shop, 9.Book_store, 10.Bowling, 11.Cafe, 12.Camping, 13.Clothes_store, 14.Club, 15.DVD
    //16.Department, 17.Electric_store, 18.Floist, 19.Hotel, 20.Jewelry_store, 21.Library
    //22.Movie, 23.Museum, 24.Music, 25.PC, 26.Park, 27.Pet_store, 28.Shoes_store, 29.Shopping
    //30.Spa, 31.Sports, 32.University, 33.Wine, 34. Yoga, 35.Zoo, 36.furniture_store
    var keywords = ["놀이공원", "수족관", "미술관", "빵집", "바", "미용실", "뷰티샵", "자전거", "서점", "볼링장", "카페", "캠핑장", "옷가게", "클럽", "dvd방", "백화점", "전자상가", "꽃집", "숙박", "보석상", "도서관", "영화관", "박물관", "노래방", "pc방", "공원", "펫", "신발", "쇼핑몰", "스파", "경기장", "대학", "와인샵", "요가", "동물원", "가구매장"]
    
    var resultCouple = [String]()
    var resultNumberOfPeople = [String]()
    var resultMoney = [String]()
    var resultWeather = [String]()
    var resultFeeling = [String]()
    var resultTime = [String]()
    var resultPersonality = [String]()
    
    var amOrpm: String?
    var hour: Int?
    var myTime: String?
    
    var count = 0
    var final = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        agreeViewController = AgreeViewController()
        reciveData()
        resettingTime()
        setRecivedData()
        compare()
        compareWithKeyword()
        sendFinalData(send: final)
        print("마지막 상태는 => \(final)")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("여기 받았어요!! => \(recivedData)")
        print("성격도 받았어요!! => \(String(describing: recivedPersonality))")
        print("현재 시각은요!! -> \(String(describing: myTime))")
    }
    
    func reciveData() {
        recivedCouple = recivedData["couple"]
        recivedNumberOfPeople = recivedData["numberOfPeople"]
        recivedMoney = recivedData["money"]
        recivedWeather = recivedData["weather"]
        recivedFeeling = recivedData["feeling"]
        recivedTime = recivedData["time"]
        
        for _ in 0 ... keywords.count - 1 {
            resultCouple.append("")
            resultNumberOfPeople.append("")
            resultMoney.append("")
            resultWeather.append("")
            resultFeeling.append("")
            resultTime.append("")
            resultPersonality.append("")
        }
    }
    
    func resettingTime() {
        if let time = recivedTime {
            let p: String.Index = time.index(time.startIndex, offsetBy: 3)
            let m: String.Index = time.index(time.startIndex, offsetBy: 4)
            
            amOrpm = String(time[p ... m]) // 오전, 오후 구분해주는 문자열
            
            let h1: String.Index = time.index(time.startIndex, offsetBy: 0)
            let h2: String.Index = time.index(time.startIndex, offsetBy: 1)
            
            hour = Int(time[h1 ... h2]) // 현재 시간을 Int형으로
            
            if amOrpm == "PM" {
                hour = hour! + 12
            }
            
            if amOrpm == "AM" && hour == 12 {
                hour = hour! + 12
            }
        }
        //- 시간 나누기
        //
        //09:00 AM ~ 12 : 00 AM (오전)
        //
        //13 : 00 AM ~ 14 : 00 PM (점심)
        //
        //15 : 00 PM ~ 17 : 30 PM (오후)
        //
        //17 : 30 PM ~ 4 : 00 AM (저녁 + 술)
        //
        //4 : 00 AM ~ 09 : 00 AM (잠)
        if let hour = self.hour {
            if hour >= 9 && hour <= 12 {    //오전
                myTime = "오전"
            } else if hour >= 13 && hour <= 14 { //점심
                myTime = "점심"
            } else if hour >= 15 && hour <= 17 { //오후
                myTime = "오후"
            } else if hour >= 18 && hour <= 24 { //저녁
                myTime = "저녁"
            } else if  hour >= 1 && hour <= 4 {
                myTime = "저녁"
            }else if hour >= 5 && hour <= 8 { //잠
                myTime = "밤"
            }
        }
    }
    
    func setRecivedData() {
        if recivedCouple == "Y" {
            processedCoupleData = 1
        } else if recivedCouple == "N" {
            processedCoupleData = 0
        } else {
            processedCoupleData = 2
        }
        
        if myTime == "오전" {
            processedTimeData = [1, 0, 0, 0, 0]
        } else if myTime == "저녁" {
            processedTimeData = [0, 1, 0, 0, 0]
        } else if myTime == "점심" {
            processedTimeData = [0, 0, 1, 0, 0]
        } else if myTime == "밤" {
            processedTimeData = [0, 0, 0, 1, 0]
        } else if myTime == "오후" {
            processedTimeData = [0, 0, 0, 0, 1]
        }
    }
    
    func compare() {
        for i in 0 ... 35 {
            switch recivedCouple {
            case "Y":
                if processedCoupleData == couples[i].value || couples[i].value != 0 {
                    resultCouple[i] = keywords[i]
                }
            case "N":
                if processedCoupleData == couples[i].value || couples[i].value != 1 {
                    resultCouple[i] = keywords[i]
                }
            default:
                break
            }
            
            //사용자 선택 -> 1 ~ 2 명 -> 1 ,0 ,0  DB에는 1,0,0  1,1,0  1,0,1  1,1,1
            switch recivedNumberOfPeople {
            case "1 ~ 2 명":
                if numberOfPeople[i].oneToTwo == 1 {
                    resultNumberOfPeople[i] = keywords[i]
                }
            case "3 ~ 5 명":
                if numberOfPeople[i].threeToFive == 1 {
                    resultNumberOfPeople[i] = keywords[i]
                }
            case "6 명 이상":
                if numberOfPeople[i].moreThanSix == 1 {
                    resultNumberOfPeople[i] = keywords[i]
                } // 11개가 나와야함
            default:
                break
            }
            
            switch recivedMoney {
            case "무료":
                if money[i].free == 1 {
                    resultMoney[i] = keywords[i]
                }
            case "1 ~ 5 만 원":
                if money[i].oneToFive == 1 {
                    resultMoney[i] = keywords[i]
                }
            case "6 ~ 10 만 원":
                if money[i].sixToTen == 1 {
                    resultMoney[i] = keywords[i]
                }
            case "10 만 원 이상":
                if money[i].moreThanTen == 1 {
                    resultMoney[i] = keywords[i]
                }
            default:
                break
            } //10 만원 고를 시 23 개가 나와야함
            
            switch recivedWeather {
            case "맑음":
                if weather[i].sunny == 1 {
                    resultWeather[i] = keywords[i]
                }
            case "흐림":
                if weather[i].cloudy == 1 {
                    resultWeather[i] = keywords[i]
                }
            case "비":
                if weather[i].rainy == 1 {
                    resultWeather[i] = keywords[i]
                }
            case "눈":
                if weather[i].snow == 1 {
                    resultWeather[i] = keywords[i]
                }
            default:
                break
            }// 비 고를 시 25 개
            
            switch recivedFeeling {
            case "행복":
                if feelings[i].happy == 1 {
                    resultFeeling[i] = keywords[i]
                }
            case "슬픔":
                if feelings[i].sad == 1 {
                    resultFeeling[i] = keywords[i]
                }
            case "차분":
                if feelings[i].calm == 1 {
                    resultFeeling[i] = keywords[i]
                }
            case "흥분":
                if feelings[i].exciting == 1 {
                    resultFeeling[i] = keywords[i]
                }
            default:
                break
            }
            
            switch myTime {
            case "오전":
                if time[i].am == 1 {
                    resultTime[i] = keywords[i]
                }
            case "점심":
                if time[i].launch == 1 {
                    resultTime[i] = keywords[i]
                }
            case "오후":
                if time[i].pm == 1 {
                    resultTime[i] = keywords[i]
                }
            case "저녁":
                if time[i].evening == 1 {
                    resultTime[i] = keywords[i]
                }
            case "밤":
                if time[i].night == 1 {
                    resultTime[i] = keywords[i]
                }
            default:
                break
            }
            
            if recivedPersonality?["outsider"] == personality[i].outsider || personality[i].outsider == 2 {
                if recivedPersonality?["sensory"] == personality[i].sensory || personality[i].sensory == 2 {
                    if recivedPersonality?["emotional"] == personality[i].emotional || personality[i].emotional == 2 {
                        resultPersonality[i] = keywords[i]
                    }
                }
            }
        }

    }
    

    //alert창을 나오게 하는 함수
       func showAlert(style : UIAlertController.Style){
        let alert = UIAlertController(title: "죄송합니다.", message: "추천할 만한 장소가 없어요ㅠ", preferredStyle: .alert)
           let success = UIAlertAction(title: "돌아가기", style: .default) { (action) in
               //success를 눌렀을 때 MapViewController로 이동하면서 데이터를 전해준다.
              if let viewControllers = self.navigationController?.viewControllers {
                         if viewControllers.count > 6{
                        self.navigationController?.popToViewController(viewControllers[viewControllers.count - 8], animated: true)
                             }
                         }
               }
           alert.addAction(success)
           //alert함수를 화면에 보여준다.
           self.present(alert, animated: true, completion: nil)
       }
    
    //PC방 -> 커플:예 인원:1~2 돈:1~5 날씨:맑음 기분:행복 시간:무관 성격:
    func compareWithKeyword() {
        print("start Function")
        print("커플 -> \(resultCouple)")//pc방 있음
        print("인원 -> \(resultNumberOfPeople)")//pc방 있음
        print("돈 -> \(resultMoney)")// pc방 없음
        print("날씨 -> \(resultWeather)")// 있음
        print("기분 -> \(resultFeeling)")// 없음
        print("시간 -> \(resultTime)")//있음
        print("성격 -> \(resultPersonality)")//없음
        for i in 0 ... keywords.count - 1 {
            if resultCouple[i] == keywords[i] {
                count = count + 1
            }
            
            if resultNumberOfPeople[i] == keywords[i] {
                count = count + 1
            }
            
            if resultMoney[i] == keywords[i] {
                count = count + 1
            }
            
            if resultWeather[i] == keywords[i] {
                count = count + 1
            }
            
            if resultFeeling[i] == keywords[i] {
                count = count + 1
            }
            
            if resultTime[i] == keywords[i] {
                count = count + 1
            }
            
            if resultPersonality[i] == keywords[i] {
                count = count + 1
            }
            
            if count == 7 {
                print("count -> \(count)")
                final.append(keywords[i])
            }
            print(count)
            count = 0
            print(final)
        }
        
        if final.isEmpty {
            showAlert(style: .alert)
        }
    }
    
    func sendFinalData(send: [String]) {
        if let agreeView = agreeViewController {
            print(self.final.randomElement())
            agreeView.search2 = self.final.randomElement()
//            navigationController?.pushViewController(agreeView, animated: true)
           self.navigationController?.pushViewController(agreeView, animated: true)
        }
    }
}
