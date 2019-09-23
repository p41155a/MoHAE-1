 /*
  Copyright 2018-2019 NAVER Corp.
  
  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at
  
  http://www.apache.org/licenses/LICENSE-2.0
  
  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
  */
 
 import UIKit
import SwiftyJSON
 import CoreLocation
 
 class ViewController: UIViewController, NMFMapViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,CLLocationManagerDelegate {
 
    
    var place = [JSON]()
    var naverMapView: NMFMapView?
    var json : JSON?
    let url = "https://naveropenapi.apigw.ntruss.com/map-place/v1/search?query="
    //let url = "https://openapi.naver.com/v1/search/local.json?query="
    var search : String?

    var locationManager:CLLocationManager!
    
   
    var startLat: Double?
    var startLng: Double?
    var DEFAULT_CAMERA_POSITION = NMFCameraPosition()
    var slideMenuWidth:CGFloat = 150 // ---- 1
    var menuLeftConstraints: NSLayoutConstraint?
    var menuSlideWitdthConstraints: NSLayoutConstraint?
    
    
    lazy var menuView: UIView = { // ---- 2
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var mainView: UIView = { // ---- 3
        let view = UIView()
        view.backgroundColor = UIColor.darkGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var collection : UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 60, height: 60)
    
        let CVollection = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        
        CVollection.register(MapCell.self, forCellWithReuseIdentifier: "MapCell")
        CVollection.backgroundColor = .white
        return CVollection
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        callURL(url1: url, search: search!)
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization() //권한 요청
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        self.slideMenuWidth = view.frame.width
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Menu", style: .plain, target: self, action: #selector(menuBtnTapped))
        
        
        collection.dataSource = self
        collection.delegate = self
        
        setupMenuView()
        
        
        naverMapView = NMFMapView(frame: self.view.frame)
        
        if let naverMapView = naverMapView {
         naverMapView.moveCamera(NMFCameraUpdate(position: DEFAULT_CAMERA_POSITION))
         naverMapView.addObserver(self, forKeyPath: "positionMode", options: [.new, .old, .prior], context: nil)
         naverMapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
         naverMapView.setLayerGroup(NMF_LAYER_GROUP_BUILDING, isEnabled: true)
        }
        
        menuView.addSubview(collection)
        mainView.addSubview(naverMapView!)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 120)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MapCell", for: indexPath) as! MapCell
        cell.backgroundColor = .yellow

        cell.address.text = json?["places"][indexPath.row]["phone_number"].stringValue
        cell.category.text = json?["places"][indexPath.row]["road_address"].stringValue
        cell.link.text = json?["places"][indexPath.row]["jibun_address"].stringValue
        cell.phone.text = json?["places"][indexPath.row]["name"].stringValue
        cell.title.text = json?["places"][indexPath.row]["sessionId"].stringValue
        cell.mapx = json?["places"][indexPath.row]["x"].doubleValue
        cell.mapy = json?["places"][indexPath.row]["y"].doubleValue
        addMarker(mapx: cell.mapx!, mapy: cell.mapy!)
       // addMarker(mapx: cell.mapx!, mapy: cell.mapy!)
        /*
        cell.address.text = json?["items"][indexPath.row]["address"].stringValue
        cell.category.text = json?["items"][indexPath.row]["category"].stringValue
        cell.link.text = json?["items"][indexPath.row]["link"].stringValue
        cell.phone.text = json?["items"][indexPath.row]["phone"].stringValue
        cell.title.text = json?["items"][indexPath.row]["title"].stringValue
        cell.mapx = json?["items"][indexPath.row]["mapx"].doubleValue
        cell.mapy = json?["items"][indexPath.row]["mapy"].doubleValue
        addMarker(mapx: cell.mapx!, mapy: cell.mapy!)
         */
        return cell
    }
    
    // 네이버 오픈api를 이용해서 json데이터를 가져온다
    func callURL(url1:String,search : String){
        /*
        let ClientID = "GaItH74GJLaOkyrCKE3Z"
        let ClientSecret = "SewMZJ4Jjg"
        let addQuery = url1+search+"&display=10&start=1&sort=comment"
           let encoded = addQuery.addingPercentEncoding( withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        */

        let ClientID = "r8s8v3u0v7"
        let ClientSecret = "piQ6rVdQzio89cwhhWSbbyamDdL5u5EFBckd8qae"
        
        let lat : String = startLat!.description
        let lng : String = startLng!.description
      
           //한글 검색어도 사용할 수 있도록 함
        let addQuery = url1+search+"&coordinate="+lat+","+lng
        let encoded = addQuery.addingPercentEncoding( withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        var request = URLRequest(url: URL(string: encoded!)!)
        request.httpMethod = "GET"                 //Naver 도서 API는 GET
        
        
        request.addValue(ClientID,forHTTPHeaderField: "X-NCP-APIGW-API-KEY-ID")
        request.addValue(ClientSecret,forHTTPHeaderField: "X-NCP-APIGW-API-KEY")
        /*
        request.addValue(ClientID,forHTTPHeaderField: "X-Naver-Client-Id")
        request.addValue(ClientSecret,forHTTPHeaderField: "X-Naver-Client-Secret")
  */
        //Session
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        //Task
        let task = session.dataTask(with: request) { (data, response, error) in
            //통신 성공
            if let data = data {
               self.json = JSON(data)
            }
            //통신 실패
            if let error = error {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    func addMarker(mapx : Double, mapy : Double){
        
        //let utmk = NMGTm128(x: mapx, y: mapy)
        //let latLng = utmk.toLatLng()
        // let marker = NMFMarker(position: NMGLatLng(lat: latLng.lat, lng: latLng.lng))
        
        let marker = NMFMarker(position: NMGLatLng(lat: mapx, lng: mapy))
        marker.iconImage = NMF_MARKER_IMAGE_RED
        marker.mapView = naverMapView
    }
    
    @objc func menuBtnTapped() {
        if menuLeftConstraints?.constant == 0 {
            menuLeftConstraints?.constant = -slideMenuWidth
            
        }else {
            menuLeftConstraints?.constant = 0
        }
        UIView.animate(withDuration: 0.4) {
            self.view.layoutIfNeeded()
        }
    }
}
 
extension ViewController {
    func setupMenuView(){
        self.view.addSubview(menuView)
        guard let navbarHeight = self.navigationController?.navigationBar.frame.maxY else {return} // ---- 4
            menuSlideWitdthConstraints =  menuView.widthAnchor.constraint(equalToConstant: slideMenuWidth) // ---- 5
            menuSlideWitdthConstraints!.isActive = true
            menuView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: navbarHeight).isActive = true
            menuView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
            
            menuLeftConstraints = menuView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: -slideMenuWidth)
            menuLeftConstraints!.isActive = true
            
            self.view.addSubview(mainView)
            mainView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: navbarHeight).isActive = true
            mainView.leftAnchor.constraint(equalTo: self.menuView.rightAnchor).isActive = true
            mainView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
            mainView.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
        }
 }

