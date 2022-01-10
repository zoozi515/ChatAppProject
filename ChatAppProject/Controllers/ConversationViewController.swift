//
//  ViewController.swift
//  ChatAppProject
//
//  Created by administrator on 08/01/2022.
//

import UIKit

class ConversationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            let isLoggedIn = UserDefaults.standard.bool(forKey: "logged_in")
            if !isLoggedIn {
                // present login view controller
                
                let vc = LoginViewController()
                           let nav = UINavigationController(rootViewController: vc)
                           nav.modalPresentationStyle = .fullScreen
                           present(nav, animated: false)
                
                /*Create the vc obj*/
//                let loginVC =  storyboard?.instantiateViewController(identifier: "loginVC") as! LoginViewController
//
//                /*Set the delegate*/
//                //loginVC.addNoteDelegate = self
//
//                /*Push to AddNoteVC*/
//                self.navigationController?.pushViewController(loginVC, animated: true)
                
                
            }
        }

}

