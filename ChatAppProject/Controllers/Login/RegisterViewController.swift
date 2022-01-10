//
//  RegisterViewController.swift
//  ChatAppProject
//
//  Created by administrator on 08/01/2022.
//

import UIKit
import FirebaseAuth

class RegisterViewController: UIViewController {
    private let scrollView: UIScrollView = {
           let scrollView = UIScrollView()
           scrollView.clipsToBounds = true
           return scrollView
       }()
    
    private let profileImage: UIImageView = {
        let profileImage = UIImageView()
        profileImage.image = UIImage(systemName: "person.crop.circle")
        profileImage.tintColor = .gray
        profileImage.contentMode = .scaleAspectFit
        return profileImage
    }()
    
    private let fanmeTextField: UITextField = {
        let fname_field = UITextField()
        fname_field.autocapitalizationType = .none
        fname_field.autocorrectionType = .no
        fname_field.returnKeyType = .continue
        fname_field.layer.cornerRadius = 12
        fname_field.layer.borderWidth = 1
        fname_field.layer.borderColor = UIColor.lightGray.cgColor
        fname_field.placeholder = "First Name..."
        fname_field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        fname_field.leftViewMode = .always
        fname_field.backgroundColor = .white
        return fname_field
    }()
    
    private let lnameTextField: UITextField = {
        let lanme_field = UITextField()
        lanme_field.autocapitalizationType = .none
        lanme_field.autocorrectionType = .no
        lanme_field.returnKeyType = .continue
        lanme_field.layer.cornerRadius = 12
        lanme_field.layer.borderWidth = 1
        lanme_field.layer.borderColor = UIColor.lightGray.cgColor
        lanme_field.placeholder = "Last Name..."
        lanme_field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        lanme_field.leftViewMode = .always
        lanme_field.backgroundColor = .white
        return lanme_field
    }()
    
    private let emailTextField: UITextField = {
        let email_field = UITextField()
        email_field.autocapitalizationType = .none
        email_field.autocorrectionType = .no
        email_field.returnKeyType = .continue
        email_field.layer.cornerRadius = 12
        email_field.layer.borderWidth = 1
        email_field.layer.borderColor = UIColor.lightGray.cgColor
        email_field.placeholder = "Email Address..."
        email_field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        email_field.leftViewMode = .always
        email_field.backgroundColor = .white
        return email_field
    }()
    
    private let passwordTextField: UITextField = {
        let pass_field = UITextField()
        pass_field.autocapitalizationType = .none
        pass_field.autocorrectionType = .no
        pass_field.returnKeyType = .done
        pass_field.layer.cornerRadius = 12
        pass_field.layer.borderWidth = 1
        pass_field.layer.borderColor = UIColor.lightGray.cgColor
        pass_field.placeholder = "Password..."
        pass_field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        pass_field.leftViewMode = .always
        pass_field.backgroundColor = .white
        pass_field.isSecureTextEntry = true
        return pass_field
    }()
    
    private let registerButton: UIButton = {
        let login_button = UIButton()
        login_button.setTitle("Register", for: .normal)
        login_button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        login_button.setTitleColor(.white, for: .normal)
        login_button.backgroundColor = .systemGreen
        login_button.layer.cornerRadius = 12
        login_button.layer.masksToBounds = true
        return login_button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Create New Account"
        view.backgroundColor = .white
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Register", style:.done, target: self, action: #selector(self.registerButtonPressed))

        //add main and subviews
        view.addSubview(scrollView)
        scrollView.addSubview(profileImage)
        scrollView.addSubview(fanmeTextField)
        scrollView.addSubview(lnameTextField)
        scrollView.addSubview(emailTextField)
        scrollView.addSubview(passwordTextField)
        scrollView.addSubview(registerButton)
        
        profileImage.isUserInteractionEnabled = true
        scrollView.isUserInteractionEnabled = true
        
        registerButton.addTarget(self, action: #selector(registerButtonPressed), for: .touchUpInside)
        
        emailTextField.delegate = self
        passwordTextField.delegate = self

        let gesture = UITapGestureRecognizer(target: self, action: #selector(profileImgTapped))
        gesture.numberOfTapsRequired = 1
        profileImage.addGestureRecognizer(gesture)
        
    }
    
    @objc private func profileImgTapped(){
        print("Change pic")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
        
        let imgSize = scrollView.width/3
        profileImage.frame = CGRect(x: (scrollView.width-imgSize)/2, y: 20, width: imgSize, height: imgSize)
        
        fanmeTextField.frame = CGRect(x: 30, y: profileImage.bottom + 10, width: scrollView.width - 60, height: 52)
        
        lnameTextField.frame = CGRect(x: 30, y: fanmeTextField.bottom + 10, width: scrollView.width - 60, height: 52)
        
        emailTextField.frame = CGRect(x: 30, y: lnameTextField.bottom + 10, width: scrollView.width - 60, height: 52)
        
        passwordTextField.frame = CGRect(x: 30, y: emailTextField.bottom + 10, width: scrollView.width - 60, height: 52)
        
        registerButton.frame = CGRect(x: 30, y: passwordTextField.bottom + 10, width: scrollView.width - 60, height: 52)
        
    }
        
    @objc private func registerButtonPressed(){
        
        fanmeTextField.resignFirstResponder()
        lnameTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        
        guard let user_fname = fanmeTextField.text, let user_lname = lnameTextField.text, let user_email = emailTextField.text, let user_pass = passwordTextField.text, user_pass.count >= 8,
              user_fname != "", user_lname != "", user_email != "", user_pass != "" else {
            createErrorAlert()
            return
        }
        
        DatabaseManager.shared.isUserExist(with: user_email, completion: {[weak self] exist in
            guard let strongSelf = self else{
                return
            }
            
            guard !exist else{
                //user already exist
                self?.createErrorAlert(msg:"Email Adress Already Exist!!")
                print("Exist")
                return
            }
            
            FirebaseAuth.Auth.auth().createUser(withEmail: user_email, password: user_pass, completion: { authResult, error in
                
                
                guard authResult != nil, error == nil else{
                    print("error registring \(user_email)")
                    return
                }
                
                DatabaseManager.shared.insertUser(with: ChatAppUser(first_name: user_fname, last_name: user_lname, email: user_email))
                strongSelf.navigationController?.dismiss(animated: true, completion: nil)
            })
        })
    }
    
    func createErrorAlert(msg: String = "Please fill out the information correctly"){
        let alert = UIAlertController(title: "Register Error", message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: nil))
        self.present(alert, animated: true)
    }
}

extension RegisterViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField{
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField{
            registerButtonPressed()
        }
        return true
    }
}
