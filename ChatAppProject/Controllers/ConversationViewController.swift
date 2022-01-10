//
//  ViewController.swift
//  ChatAppProject
//
//  Created by administrator on 08/01/2022.
//

import UIKit
import FirebaseAuth

class ConversationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        validateAuth()
    }
    
    private func validateAuth(){
        if FirebaseAuth.Auth.auth().currentUser == nil {
            // present login view controller
           let vc = LoginViewController()
           let nav = UINavigationController(rootViewController: vc)
           nav.modalPresentationStyle = .fullScreen
           present(nav, animated: false)
        }
    }

}

