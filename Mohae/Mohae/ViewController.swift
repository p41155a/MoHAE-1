//
//  MapViewController.swift
//  NMapSampleSwift
//
//  Created by Junggyun Ahn on 2016. 11. 9..
//  Copyright © 2016년 Naver. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKUIDelegate ,NMapViewDelegate, NMapPOIdataOverlayDelegate, NMapLocationManagerDelegate {
    
    var webView: WKWebView?
    var mapView: NMapView?
    let image = UIImage(named: "mode.png")
    var changeStateButton: UIButton?
    
    enum state {
        case disabled
        case tracking
        case trackingWithHeading
    }
    
    var currentState: state = .disabled
    
    lazy var levelStepper: UIStepper = {
        let Stepper = UIStepper()
        Stepper.translatesAutoresizingMaskIntoConstraints = false
        Stepper.frame = CGRect(x: 15, y: 30, width: 36, height: 36)
        return Stepper
    }()
    
    lazy var layerButton: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 15, y: 70, width: 36, height: 36)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(layerButtonAction), for: .touchUpInside)
        return button
    }()
    
    lazy var modeChanger: UISegmentedControl = {
        let button = UISegmentedControl()
        button.insertSegment(withTitle: "vector", at: 0, animated: true)
        button.insertSegment(withTitle: "setlite", at: 1, animated: true)
        button.insertSegment(withTitle: "hybrid", at: 2, animated: true)
        button.frame = CGRect(x: 15, y: 160, width: 200, height: 36)
        button.addTarget(self, action: #selector(modeChanged), for: .touchUpInside)
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView = NMapView(frame: self.view.bounds)
        
        if let mapView = mapView {
            // set the delegate for map view
            mapView.delegate = self
            // set the application api key for Open MapViewer Library
            mapView.setClientId("r8s8v3u0v7")
            mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            view.addSubview(mapView)
            view.addSubview(levelStepper)
            view.addSubview(layerButton)
            view.addSubview(modeChanger)
            // Zoom 용 UIStepper 셋팅.
            initLevelStepper(mapView.minZoomLevel(), maxValue:mapView.maxZoomLevel(), initialValue:11)
            view.bringSubviewToFront(levelStepper)
            
            mapView.setBuiltInAppControl(true)
           
            roadSearch()
        }
        
        changeStateButton = createButton()
        
        if let button = changeStateButton {
            view.addSubview(button)
        }
        
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let url = navigationAction.request.url {
            if url.scheme == "nmap" {
                UIApplication.shared.open(url)
                decisionHandler(.cancel)
                return
            }
        }
        decisionHandler(.allow)
    }
    
    func roadSearch(){
        
        let url = URL(string: "nmap://actionPath?parameter=value&appname=com.today.Mohae")!
        let appStoreURL = URL(string: "http://itunes.apple.com/app/id311867728?mt=8")!
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        } else {
            UIApplication.shared.open(appStoreURL)
        }

    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        if view.frame.size.width != size.width {
            if let mapView = mapView, mapView.isAutoRotateEnabled {
                mapView.setAutoRotateEnabled(false, animate: false)
                
                coordinator.animate(alongsideTransition: {(context: UIViewControllerTransitionCoordinatorContext) -> Void in
                    if let mapView = self.mapView {
                        mapView.setAutoRotateEnabled(true, animate: false)
                    }
                }, completion: nil)
                
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        mapView?.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        mapView?.viewWillAppear()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        mapView?.viewDidDisappear()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        mapView?.viewDidAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        mapView?.viewWillDisappear()
        
        stopLocationUpdating()
    }
    
    // MARK: - NMapViewDelegate
    
    open func onMapView(_ mapView: NMapView!, initHandler error: NMapError!) {
        if (error == nil) { // success
            // set map center and level
            mapView.setMapCenter(NGeoPoint(longitude:126.978371, latitude:37.5666091), atLevel:11)
            // set for retina display
            mapView.setMapEnlarged(true, mapHD: true)
            // set map mode : vector/satelite/hybrid
            mapView.mapViewMode = .vector
        } else { // fail
            print("onMapView:initHandler: \(error.description)")
        }
    }
    
    // MARK: - NMapPOIdataOverlayDelegate
    
    open func onMapOverlay(_ poiDataOverlay: NMapPOIdataOverlay!, imageForOverlayItem poiItem: NMapPOIitem!, selected: Bool) -> UIImage! {
        return NMapViewResources.imageWithType(poiItem.poiFlagType, selected: selected)
    }
    
    open func onMapOverlay(_ poiDataOverlay: NMapPOIdataOverlay!, anchorPointWithType poiFlagType: NMapPOIflagType) -> CGPoint {
        return NMapViewResources.anchorPoint(withType: poiFlagType)
    }
    
    open func onMapOverlay(_ poiDataOverlay: NMapPOIdataOverlay!, calloutOffsetWithType poiFlagType: NMapPOIflagType) -> CGPoint {
        return CGPoint(x: 0, y: 0)
    }
    
    open func onMapOverlay(_ poiDataOverlay: NMapPOIdataOverlay!, imageForCalloutOverlayItem poiItem: NMapPOIitem!, constraintSize: CGSize, selected: Bool, imageForCalloutRightAccessory: UIImage!, calloutPosition: UnsafeMutablePointer<CGPoint>!, calloutHit calloutHitRect: UnsafeMutablePointer<CGRect>!) -> UIImage! {
        return nil
    }
    
    // MARK: - Layer Button
    @objc func layerButtonAction(_ sender: UIBarButtonItem) {
        
        let alertController = UIAlertController(title: "Layers", message: nil, preferredStyle: .actionSheet)
        
        if let map = mapView {
            // Action Sheet 생성
            
            let trafficAction = UIAlertAction(title: "Traffic layer is " + (map.mapViewTrafficMode ? "On" : "Off"), style: .default, handler: { (action) -> Void in
                print("Traffic layer Selected...")
                map.mapViewTrafficMode = !map.mapViewTrafficMode
            })
            
            let bicycleAction = UIAlertAction(title: "Bicycle layer is " + (map.mapViewBicycleMode ? "On" : "Off"), style: .default, handler: { (action) -> Void in
                print("Traffic layer Selected...")
                map.mapViewBicycleMode = !map.mapViewBicycleMode
            })
            
            let inDoorAction = UIAlertAction(title: "indoor layer is " + (map.mapViewIndoorMode ? "On" : "Off"), style: .default, handler: { (action) -> Void in
                print("Traffic layer Selected...")
                map.mapViewIndoorMode = !map.mapViewIndoorMode
            })
            
            let panoramaMode = UIAlertAction(title: "panorama layer is " + (map.mapViewPanoramaMode ? "On" : "Off"), style: .default, handler: { (action) -> Void in
                print("Traffic layer Selected...")
                map.mapViewPanoramaMode = !map.mapViewPanoramaMode
            })
            
            let cadastralMode = UIAlertAction(title: "cadastral layer is " + (map.mapViewCadastralMode ? "On" : "Off"), style: .default, handler: { (action) -> Void in
                print("Traffic layer Selected...")
                map.mapViewCadastralMode = !map.mapViewCadastralMode
            })
            
            let alphaAction = UIAlertAction(title: "Alpha layer is " + (map.mapViewAlphaLayerMode ? "On" : "Off"), style: .default, handler: { (action) -> Void in
                print("Alpha layer Selected...")
                map.mapViewAlphaLayerMode = !map.mapViewAlphaLayerMode
                
                //                지도 위 반투명 레이어에 색을 지정할 때에는 다음 메서드를 사용한다
                //                map.setMapViewAlphaLayerMode(!map.mapViewAlphaLayerMode, with: UIColor(red: 0.5, green: 1.0, blue: 0.5, alpha: 0.9))
            })
            
            alertController.addAction(panoramaMode)
            alertController.addAction(trafficAction)
            alertController.addAction(bicycleAction)
            alertController.addAction(alphaAction)
        }
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Map Mode Segmented Control
    
    @objc func modeChanged() {
        if modeChanger.selectedSegmentIndex == 0 {
            mapView?.mapViewMode = .vector
        } else if modeChanger.selectedSegmentIndex == 1 {
            mapView?.mapViewMode = .satellite
        } else if modeChanger.selectedSegmentIndex == 2 {
            mapView?.mapViewMode = .hybrid
        } else {
            mapView?.mapViewMode = .vector
        }
    }
    
    // MARK: - Level Stepper
    
    func initLevelStepper(_ minValue: Int32, maxValue: Int32, initialValue: Int32) {
        levelStepper.minimumValue = Double(minValue)
        levelStepper.maximumValue = Double(maxValue)
        levelStepper.stepValue = 1
        levelStepper.value = Double(initialValue)
    }
    
    @IBAction func levelStepperValeChanged(_ sender: UIStepper) {
        mapView?.setZoomLevel(Int32(sender.value))
    }
    
    
    // MARK: - NMapLocationManagerDelegate Methods
    
    open func locationManager(_ locationManager: NMapLocationManager!, didUpdateTo location: CLLocation!) {
        
        let coordinate = location.coordinate
        
        let myLocation = NGeoPoint(longitude: coordinate.longitude, latitude: coordinate.latitude)
        let locationAccuracy = Float(location.horizontalAccuracy)
        
        mapView?.mapOverlayManager.setMyLocation(myLocation, locationAccuracy: locationAccuracy)
        mapView?.setMapCenter(myLocation)
    }
    
    open func locationManager(_ locationManager: NMapLocationManager!, didFailWithError errorType: NMapLocationManagerErrorType) {
        
        var message: String = ""
        
        switch errorType {
        case .unknown: fallthrough
        case .canceled: fallthrough
        case .timeout:
            message = "일시적으로 내위치를 확인 할 수 없습니다."
        case .denied:
            message = "위치 정보를 확인 할 수 없습니다.\n사용자의 위치 정보를 확인하도록 허용하시려면 위치서비스를 켜십시오."
        case .unavailableArea:
            message = "현재 위치는 지도내에 표시할 수 없습니다."
        case .heading:
            message = "나침반 정보를 확인 할 수 없습니다."
        }
        
        if (!message.isEmpty) {
            let alert = UIAlertController(title:"NMapViewer", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title:"OK", style:.default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
        
        if let mapView = mapView, mapView.isAutoRotateEnabled {
            mapView.setAutoRotateEnabled(false, animate: true)
        }
    }
    
    func locationManager(_ locationManager: NMapLocationManager!, didUpdate heading: CLHeading!) {
        let headingValue = heading.trueHeading < 0.0 ? heading.magneticHeading : heading.trueHeading
        setCompassHeadingValue(headingValue)
    }
    
    func onMapViewIsGPSTracking(_ mapView: NMapView!) -> Bool {
        return NMapLocationManager.getSharedInstance().isTrackingEnabled()
    }
    
    func findCurrentLocation() {
        enableLocationUpdate()
    }
    
    func setCompassHeadingValue(_ headingValue: Double) {
        
        if let mapView = mapView, mapView.isAutoRotateEnabled {
            mapView.setRotateAngle(Float(headingValue), animate: true)
        }
    }
    
    func stopLocationUpdating() {
        
        disableHeading()
        disableLocationUpdate()
    }
    
    // MARK: - My Location
    
    func enableLocationUpdate() {
        
        if let lm = NMapLocationManager.getSharedInstance() {
            
            if lm.locationServiceEnabled() == false {
                locationManager(lm, didFailWithError: .denied)
                return
            }
            
            if lm.isUpdateLocationStarted() == false {
                // set delegate
                lm.setDelegate(self)
                // start updating location
                lm.startContinuousLocationInfo()
            }
        }
    }
    
    func disableLocationUpdate() {
        
        if let lm = NMapLocationManager.getSharedInstance() {
            
            if lm.isUpdateLocationStarted() {
                // start updating location
                lm.stopUpdateLocationInfo()
                // set delegate
                lm.setDelegate(nil)
            }
        }
        
        mapView?.mapOverlayManager.clearMyLocationOverlay()
    }
    
    // MARK: - Compass
    
    func enableHeading() -> Bool {
        
        if let lm = NMapLocationManager.getSharedInstance() {
            
            let isAvailableCompass = lm.headingAvailable()
            
            if isAvailableCompass {
                
                mapView?.setAutoRotateEnabled(true, animate: true)
                
                lm.startUpdatingHeading()
            } else {
                return false
            }
        }
        
        return true;
    }
    
    func disableHeading() {
        if let lm = NMapLocationManager.getSharedInstance() {
            
            let isAvailableCompass = lm.headingAvailable()
            
            if isAvailableCompass {
                lm.stopUpdatingHeading()
            }
        }
        
        mapView?.setAutoRotateEnabled(false, animate: true)
    }
    
    // MARK: - Button Control
    
    func createButton() -> UIButton? {
        
        let button = UIButton(type: .custom)
        
        button.frame = CGRect(x: 15, y: 120, width: 36, height: 36)
        button.setImage(#imageLiteral(resourceName: "v4_btn_navi_location_normal"), for: .normal)
        button.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
        
        return button
    }
    
    
    @objc func buttonClicked(_ sender: UIButton!) {
        
        if let lm = NMapLocationManager.getSharedInstance() {
            
            switch currentState {
            case .disabled:
                enableLocationUpdate()
                updateState(.tracking)
            case .tracking:
                let isAvailableCompass = lm.headingAvailable()
                
                if isAvailableCompass {
                    enableLocationUpdate()
                    if enableHeading() {
                        updateState(.trackingWithHeading)
                    }
                } else {
                    stopLocationUpdating()
                    updateState(.disabled)
                }
            case .trackingWithHeading:
                stopLocationUpdating()
                updateState(.disabled)
            }
        }
    }
    
    func updateState(_ newState: state) {
        
        currentState = newState
        
        switch currentState {
        case .disabled:
            changeStateButton?.setImage(#imageLiteral(resourceName: "v4_btn_navi_location_normal"), for: .normal)
        case .tracking:
            changeStateButton?.setImage(#imageLiteral(resourceName: "v4_btn_navi_location_selected"), for: .normal)
        case .trackingWithHeading:
            changeStateButton?.setImage(#imageLiteral(resourceName: "v4_btn_navi_location_my"), for: .normal)
        }
    }
}

