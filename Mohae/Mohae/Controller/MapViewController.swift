import UIKit
import GoogleMaps
import GooglePlaces
import SwiftyJSON

class MapViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var json : JSON?
    
    var defaultLocation = CLLocation(latitude: -33.869405, longitude: 151.199)
    
    var mapView : GMSMapView!
    var placesClient : GMSPlacesClient!
    var zoomLevel : Float = 15.0
    
    var slideWidth : CGFloat = 50 // 의미없음
    var menuLeftConstraints: NSLayoutConstraint?
    
    let url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location="
    let radiusType = "&language=ko&rankby=distance&type="
    let search = "restaurant"
    let key = "&key="
    
    lazy var googleMapView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints  = false
        return view
    }()
    
    lazy var listView : UIView = {
       let view = UIView()
       view.translatesAutoresizingMaskIntoConstraints = false
       return view
    }()
    
    lazy var collectionList : UICollectionView = {
        let layout : UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 60, height: 60)
        
        let CV = UICollectionView(frame:  self.view.frame, collectionViewLayout: layout)
        
        CV.register(MapSearchCell.self, forCellWithReuseIdentifier: "MapSearchCell")
        CV.backgroundColor = .white
        return CV
    }()

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        collectionList.delegate = self
        collectionList.dataSource = self
        slideWidth = view.frame.width
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem:.add,target: self, action:#selector(menuBtnTapped))
        
        placesClient = GMSPlacesClient.shared()
    
        let camera = GMSCameraPosition.camera(withLatitude: defaultLocation.coordinate.latitude, longitude: defaultLocation.coordinate.longitude, zoom: zoomLevel)
        
        mapView = GMSMapView.map(withFrame: googleMapView.bounds, camera: camera)
        mapView.settings.myLocationButton = true
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.isMyLocationEnabled = true
        
        googleMapView.addSubview(mapView)
        listView.addSubview(collectionList)
        
        mapView.isHidden = false
        
        setupMapView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 120)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 19
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MapSearchCell", for: indexPath) as! MapSearchCell
        cell.backgroundColor = .yellow
        cell.name.text = json?["results"][indexPath.row]["name"].stringValue
        cell.type.text = json?["results"][indexPath.row]["types"][0].stringValue
        cell.type2.text = json?["results"][indexPath.row]["types"][1].stringValue
        cell.id = json?["results"][indexPath.row]["id"].stringValue
        cell.place_id = json?["results"][indexPath.row]["place_id"].stringValue
        cell.lat = json?["results"][indexPath.row]["geometry"]["location"]["lat"].doubleValue
        cell.lng = json?["results"][indexPath.row]["geometry"]["location"]["lng"].doubleValue
        
        return cell
    }
    
    @objc func menuBtnTapped() {
        if menuLeftConstraints?.constant == 0{
            menuLeftConstraints?.constant = -slideWidth
        } else {
            menuLeftConstraints?.constant = 0
        }
        UIView.animate(withDuration: 0.4){
            self.view.layoutIfNeeded()
        }
    }
}

extension MapViewController {
    func setupMapView() {
        
        self.view.addSubview(listView)
        
        guard  let navbarHeight = self.navigationController?.navigationBar.frame.maxY else {return} // navbar 상단에 view가 침범하지 않도록 하기 위한 조치.
        
        listView.widthAnchor.constraint(equalToConstant: slideWidth).isActive = true
        listView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: navbarHeight).isActive = true // navbar의 높이만큼 띄워준다.
        listView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        menuLeftConstraints = listView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: -slideWidth)
        menuLeftConstraints!.isActive = true
        
        self.view.addSubview(googleMapView)
        
        googleMapView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: navbarHeight).isActive = true
        googleMapView.leftAnchor.constraint(equalTo: self.listView.rightAnchor).isActive = true
        googleMapView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        googleMapView.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
    }
}
