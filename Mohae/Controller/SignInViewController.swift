//
//  SignInViewController.swift
//  Mohae
//
//  Created by Doyun on 10/10/2019.
//  Copyright © 2019 Doyun. All rights reserved.
//


import UIKit
import Firebase

class SignInViewController: UIViewController {
    
    

    var signLogo = UILabel()
    var signemailField = UITextField()
    var signpasswordField = UITextField()
    var signnameField = UITextField()
    var signphoneField = UITextField()
    var signButton = UIButton()
    var memberDatas = [String]()
    
    
    func signLogoLayout() {
        signLogo.text = "MoHAE 회원가입"
        signLogo.font = UIFont.systemFont(ofSize: CGFloat(20))
        signLogo.textAlignment = NSTextAlignment.center
        signLogo.snp.makeConstraints { make in
            make.centerX.equalTo(self.view)
            make.leading.equalTo(100)
            make.trailing.equalTo(-100)
            make.top.equalTo(20)
        }
    }
    
    func signemailFieldLayout() {
       
        signemailField.placeholder = "이메일을 입력하세요."
        signemailField.keyboardType = .emailAddress
        signemailField.autocapitalizationType = .none
        signemailField.snp.makeConstraints { make in
            make.centerX.equalTo(self.view)
            make.leading.equalTo(50)
            make.trailing.equalTo(-50)
            make.top.equalTo(120)
        }
        underLineViewLayout(textField: self.signemailField)
        
    }
    
    func signpasswordFieldLayout() {
        
        signpasswordField.placeholder = "비밀번호를 입력하세요."
        signpasswordField.isSecureTextEntry = true
        signpasswordField.autocapitalizationType = .none
        signpasswordField.snp.makeConstraints{ make in
            make.centerX.equalTo(self.view)
            make.leading.equalTo(50)
            make.trailing.equalTo(-50)
            make.top.equalTo(signemailField.snp.bottom).offset(50)
        }
        underLineViewLayout(textField: self.signpasswordField)
    }
    
    func signnameFieldLayout() {
        
        signnameField.placeholder = "이름을 입력하세요."
        signnameField.autocapitalizationType = .none
        signnameField.snp.makeConstraints{ make in
            make.centerX.equalTo(self.view)
            make.leading.equalTo(50)
            make.trailing.equalTo(-50)
            make.top.equalTo(signpasswordField.snp.bottom).offset(50)
        }
        underLineViewLayout(textField: self.signnameField)
    }
    
    func signphoneFieldLayout() {
        
        signphoneField.placeholder = "핸드폰번호를 입력하세요."
        signphoneField.autocapitalizationType = .none
        signphoneField.snp.makeConstraints{ make in
            make.centerX.equalTo(self.view)
            make.leading.equalTo(50)
            make.trailing.equalTo(-50)
            make.top.equalTo(signnameField.snp.bottom).offset(50)
        }
        underLineViewLayout(textField: self.signphoneField)
    }
    
    func signButtonLayout() {
        signButton.setTitle("가입하기", for: .normal)
        signButton.setTitleColor(.white, for: .normal)
        signButton.backgroundColor = .lightGray
        //loginButton1.layer.cornerRadius = 10
        signButton.addTarget(self, action: #selector(signSuccess(_:)), for: .touchUpInside)
        signButton.snp.makeConstraints{ make in
            make.centerX.equalTo(self.view)
            make.leading.equalTo(30)
            make.trailing.equalTo(-30)
            make.top.equalTo(signphoneField.snp.bottom).offset(100)
        }
       
    }
    
    func underLineViewLayout(textField: UITextField) {
        let underLineView = UIView()
        self.view.addSubview(underLineView)
        underLineView.backgroundColor = .darkGray
        underLineView.snp.makeConstraints{ make in
            make.height.equalTo(0.5)
            make.leading.equalTo(48)
            make.trailing.equalTo(-70)
            make.top.equalTo(textField.snp.bottom).offset(12)
        }
    }
    
    func successAlert() {
        let next:SurveyViewController = SurveyViewController()
        
        self.present(next, animated: true, completion: nil)
        
        

        // 회원정보 데이터 저장
        let memRef = Database.database().reference().child("members").setValue([
            "userId": Auth.auth().currentUser?.email,
            "userName": self.signnameField.text,
            "userPhone": self.signphoneField.text
        
        ])

        
         

    }
    
    @objc func signSuccess(_ sender: Any) {
        
        Auth.auth().createUser(withEmail: signemailField.text!, password: signpasswordField.text!) { (authResult, error) in
        if authResult != nil {
            //upload profile image
            // let storageRef = Storage.storage().reference().child("profile_images").child("\(imageName).png")
            //profile image로 사용할 때 두 가지 크기의 이미지로 저장할 수 있도록 한다.

                            if let email = self.signemailField.text {
                                if let name = self.signnameField.text {
                                    if let phone = self.signphoneField.text {
                                        let values = ["isinit": 0, "email" : email, "name" : name, "phone" : phone] as [String : AnyObject]
                                    let ref = Database.database().reference()
                                    let reference = ref.child("users").child((authResult?.user.uid)!)
                                    reference.updateChildValues(values)
                                }
                            }
                       
                    
               
            }
            
            //Move to Login View
           let next:SurveyViewController = SurveyViewController()
            
           self.present(next, animated: true, completion: nil)
        }
        }
    }
        
        
        
        
//        Auth.auth().createUser(withEmail: signemailField.text!, password: signpasswordField.text!
//
//                ) { (user, error) in
//
//                    if user !=  nil{
//                        print("register success")
//                        self.successAlert()
//                    }
//                    else{
//                        print("register failed")
//                    }
//                }}

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        self.view.addSubview(signLogo)
        self.view.addSubview(signemailField)
        self.view.addSubview(signpasswordField)
        self.view.addSubview(signnameField)
        self.view.addSubview(signphoneField)
        self.view.addSubview(signButton)
        
        self.signLogoLayout()
        self.signemailFieldLayout()
        self.signpasswordFieldLayout()
        self.signnameFieldLayout()
        self.signphoneFieldLayout()
        self.signButtonLayout()
        // Do any additional setup after loading the view.
    }
    

    
    

}
