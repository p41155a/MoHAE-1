//
//  AgreeViewController.swift
//  Mohae
//
//  Created by 권혁준 on 19/09/2019.
//  Copyright © 2019 권혁준. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation
 import NMapsMap

class AgreeViewController: UIViewController, CLLocationManagerDelegate {

    var search = "음식점"
    var delegate : ViewController?
     var locationManager:CLLocationManager!
    
    lazy var button: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(agree), for: .touchUpInside)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization() //권한 요청
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
         navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem:.add,target: self, action:#selector(agree(sender:)))
        view.addSubview(button)
    }
    
    @objc func agree(sender:UIButton)
    {
        let view = ViewController()
        view.search = "음식점"
        view.startLng=locationManager.location?.coordinate.latitude
        view.startLat=locationManager.location?.coordinate.longitude
        view.DEFAULT_CAMERA_POSITION = NMFCameraPosition(NMGLatLng(lat: (locationManager.location?.coordinate.latitude)!, lng: (locationManager.location?.coordinate.longitude)!), zoom: 15, tilt: 0, heading: 0 )
        
        self.navigationController?.pushViewController(view, animated: true)
    }
    
    
}
