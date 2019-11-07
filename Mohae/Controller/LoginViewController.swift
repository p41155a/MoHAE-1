//
//  LoginViewController.swift
//  Mohae
//
//  Created by Doyun on 10/10/2019.
//  Copyright © 2019 Doyun. All rights reserved.
//

import UIKit
import SnapKit
import Firebase
import CoreLocation

class LoginViewController: UIViewController, CLLocationManagerDelegate {
  

     var mainLogo = UILabel()
     var emailField = UITextField()
     var passwordField = UITextField()
     var loginButton1 = UIButton()
     var signInButton = UIButton()
    var locationManager:CLLocationManager?
    
    override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            //위치가 업데이트될때마다
            if let coor = manager.location?.coordinate{
                print("latitude" + String(coor.latitude) + "/ longitude" + String(coor.longitude))
            }
        }

  private let loginButton: KOLoginButton = {
    let button = KOLoginButton()
    button.addTarget(self, action: #selector(touchUpLoginButton(_:)), for: .touchUpInside)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()

    func mainLogoLayout() {
        
        mainLogo.text = "MoHAE?"
        let attributedStr = NSMutableAttributedString(string: mainLogo.text!)
        attributedStr.addAttribute(.foregroundColor, value: UIColor.systemPink
            , range: (mainLogo.text! as NSString).range(of: "HAE?"))
        attributedStr.addAttribute(.foregroundColor, value: UIColor.lightGray, range: (mainLogo.text! as NSString).range(of: "Mo"))
        
        mainLogo.attributedText = attributedStr
        mainLogo.font = UIFont.systemFont(ofSize: CGFloat(25))
        mainLogo.textAlignment = NSTextAlignment.center
        mainLogo.snp.makeConstraints { make in
            make.centerX.equalTo(self.view)
            make.leading.equalTo(100)
            make.trailing.equalTo(-100)
            make.top.equalTo(40)
        }
    }
    
    func emailFieldLayout() {
       
        emailField.placeholder = "이메일을 입력하세요."
        emailField.keyboardType = .emailAddress
        emailField.autocapitalizationType = .none
        emailField.snp.makeConstraints { make in
            make.centerX.equalTo(self.view)
            make.leading.equalTo(50)
            make.trailing.equalTo(-50)
            make.top.equalTo(120)
        }
        underLineViewLayout(textField: self.emailField)
        
    }
    
    func passwordFieldLayout() {
        
        passwordField.placeholder = "비밀번호를 입력하세요."
        passwordField.isSecureTextEntry = true
        passwordField.autocapitalizationType = .none
        passwordField.snp.makeConstraints{ make in
            make.centerX.equalTo(self.view)
            make.leading.equalTo(50)
            make.trailing.equalTo(-50)
            make.top.equalTo(emailField.snp.bottom).offset(50)
        }
        underLineViewLayout(textField: self.passwordField)
    }
    
    func loginButton1Layout() {
        loginButton1.setTitle("Login", for: .normal)
        loginButton1.setTitleColor(.white, for: .normal)
        loginButton1.backgroundColor = .systemPink
        loginButton1.addTarget(self, action: #selector(moveLogin(_:)), for: .touchUpInside)
        //loginButton1.layer.cornerRadius = 10
        
        loginButton1.snp.makeConstraints{ make in
            make.centerX.equalTo(self.view)
            make.leading.equalTo(30)
            make.trailing.equalTo(-30)
            make.top.equalTo(passwordField.snp.bottom).offset(100)
        }

    }

    func signInButtonLayout() {
        signInButton.setTitle("Sign In", for: .normal)
        signInButton.setTitleColor(.white, for: .normal)
        signInButton.backgroundColor = .systemPink
        //loginButton1.layer.cornerRadius = 10
        signInButton.addTarget(self, action: #selector(movesign(_:)), for: .touchUpInside)
        signInButton.snp.makeConstraints{ make in
            make.centerX.equalTo(self.view)
            make.leading.equalTo(30)
            make.trailing.equalTo(-30)
            make.top.equalTo(loginButton1.snp.bottom).offset(20)
        }
       
    }
        
    func underLineViewLayout(textField: UITextField) {
        let underLineView = UIView()
        self.view.addSubview(underLineView)
        underLineView.backgroundColor = .lightGray
        underLineView.snp.makeConstraints{ make in
            make.height.equalTo(0.5)
            make.leading.equalTo(48)
            make.trailing.equalTo(-70)
            make.top.equalTo(textField.snp.bottom).offset(12)
        }
    }
    
    func errorAlert(){
        let alert = UIAlertController(title: "로그인 실패", message:"이메일 또는 비밀 번호가 다릅니다", preferredStyle: .alert)
        let success = UIAlertAction(title: "확인", style: .default) { (action) in
            //success를 눌렀을 때 MapViewController로 이동하면서 데이터를 전해준다.
             self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(success)
        self.present(alert, animated: true, completion: nil)
    }

    
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    
    navigationController?.isNavigationBarHidden = true
    
    self.view.addSubview(emailField)
    self.view.addSubview(passwordField)
    self.view.addSubview(loginButton1)
    self.view.addSubview(signInButton)
    self.view.addSubview(mainLogo)
    
    
    self.loginButton1Layout()
    self.emailFieldLayout()
    self.passwordFieldLayout()
    self.signInButtonLayout()
    self.mainLogoLayout()
    
    layout()


  }
    
    override func loadView() {
        super.loadView()
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization() //권한 요청
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.startUpdatingLocation()
    }
   

    
  //카카오 로그인시 구현되는 
  @objc private func touchUpLoginButton(_ sender: UIButton) {
    guard let session = KOSession.shared() else {
      return
    }
    
    if session.isOpen() {
      session.close()
    }
    
    session.open { (error) in
      if error != nil || !session.isOpen() { return }
      KOSessionTask.userMeTask(completion: { (error, user) in
//        guard let user = user,
//              let email = user.account?.email,
//              let nickname = user.nickname else { return }
        
        let mainVC = SurveyViewController()
        //mainVC.emailLabel.text = email
        //mainVC.nicnameLabel.text = nickname
        
        self.present(mainVC, animated: true, completion: nil)
      })
    }
  }
    
    
    @objc func movesign(_ sender: UIButton) {
        let next:SignInViewController = SignInViewController()
        
        self.present(next, animated: true, completion: nil)
    }
    
    @objc func moveLogin(_ sender: UIButton) {
       Auth.auth().signIn(withEmail: emailField.text!, password: passwordField.text!) { (user, error) in

                    if user != nil{
                        print("login success")
                    Database.database().reference().child("users").child((Auth.auth().currentUser?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
                            if let dictionary = snapshot.value as? [String: AnyObject] {
                                let isinit = dictionary["isinit"] as? Int
                                if(isinit == 1){
                                    self.navigationController?.pushViewController(RecommendButtonController(), animated: true)
                                }else{
                                  self.navigationController?.pushViewController(SurveyViewController(), animated: true)
                                }
                            }
                        }, withCancel: nil)
                    }
                    else{
                        print("login fail")
                        self.errorAlert()
                    }
              }
    }
    

  private func layout() {
    let guide = view.safeAreaLayoutGuide
    view.addSubview(loginButton)
    
    loginButton.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 20).isActive = true
    loginButton.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -20).isActive = true
    loginButton.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: -30).isActive = true
    loginButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    
  }
}
