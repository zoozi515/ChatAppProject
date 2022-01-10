//
//  LoginViewController.swift
//  ChatAppProject
//
//  Created by administrator on 08/01/2022.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    private let scrollView: UIScrollView = {
           let scrollView = UIScrollView()
           scrollView.clipsToBounds = true
           return scrollView
       }()
    
    private let logoImage: UIImageView = {
        let logoImage = UIImageView()
        logoImage.image = UIImage(named: "LogoImage")
        logoImage.contentMode = .scaleAspectFit
        return logoImage
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
    
    private let loginButton: UIButton = {
        let login_button = UIButton()
        login_button.setTitle("Log In", for: .normal)
        login_button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        login_button.setTitleColor(.white, for: .normal)
        login_button.backgroundColor = .blue
        login_button.layer.cornerRadius = 12
        login_button.layer.masksToBounds = true
        return login_button
    }()
    
    private let fbLoginButton: UIButton = {
        let login_button = UIButton()
        login_button.setTitle("Continue with Facebook", for: .normal)
        login_button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        login_button.setTitleColor(.white, for: .normal)
        login_button.backgroundColor = .blue
        login_button.layer.cornerRadius = 12
        login_button.layer.masksToBounds = true
        return login_button
    }()
    
    private let gLoginButton: UIButton = {
        let login_button = UIButton()
        login_button.setTitle("Sign In", for: .normal)
        login_button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        login_button.setTitleColor(.white, for: .normal)
        login_button.backgroundColor = .blue
        login_button.layer.cornerRadius = 12
        login_button.layer.masksToBounds = true
        return login_button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Log In"
        view.backgroundColor = .white

        //add main and subviews
        view.addSubview(scrollView)
        scrollView.addSubview(logoImage)
        scrollView.addSubview(emailTextField)
        scrollView.addSubview(passwordTextField)
        scrollView.addSubview(loginButton)
        scrollView.addSubview(fbLoginButton)
        scrollView.addSubview(gLoginButton)
        
        loginButton.addTarget(self, action: #selector(loginButtonPressed), for: .touchUpInside)
        
        emailTextField.delegate = self
        passwordTextField.delegate = self


        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Register", style:.done, target: self, action: #selector(self.registerButtonPressed))
    
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
        
        let imgSize = scrollView.width/3
        logoImage.frame = CGRect(x: (scrollView.width-imgSize)/2, y: 20, width: imgSize, height: imgSize)
        
        emailTextField.frame = CGRect(x: 30, y: logoImage.bottom + 10, width: scrollView.width - 60, height: 52)
        
        passwordTextField.frame = CGRect(x: 30, y: emailTextField.bottom + 10, width: scrollView.width - 60, height: 52)
        
        loginButton.frame = CGRect(x: 30, y: passwordTextField.bottom + 10, width: scrollView.width - 60, height: 52)
        
        fbLoginButton.frame = CGRect(x: 30, y: loginButton.bottom + 10, width: scrollView.width - 60, height: 52)
        
        gLoginButton.frame = CGRect(x: 30, y: fbLoginButton.bottom + 10, width: scrollView.width - 60, height: 52)
    }
    
    @objc private func registerButtonPressed(){
        let rvc = RegisterViewController()
        rvc.title = "Create New Account"
        navigationController?.pushViewController(rvc, animated: true)
    }
    
    @objc private func loginButtonPressed(){
        
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        
        guard let user_email = emailTextField.text, let user_pass = passwordTextField.text, user_pass.count >= 8, user_email != "",
              user_pass != "" else {
            createAlert()
            return
        }
        FirebaseAuth.Auth.auth().signIn(withEmail: user_email, password: user_pass, completion: {authResult, error in
            guard let result = authResult, error == nil else{
                print("login fialed \(user_email)")
                return
            }
            
            let user = result.user
            print("Login user: \(user)")
        })
    }
    
    func createAlert(){
        let alert = UIAlertController(title: "Login Error", message: "Please fill out the information correctly", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: nil))
        self.present(alert, animated: true)
    }
}

extension LoginViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField{
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField{
            loginButtonPressed()
        }
        return true
    }
}
