//
//  SigninViewController.swift
//  CrimeApp
//
//  Created by lucas on 10/31/20.
//  Copyright © 2020 lucas. All rights reserved.
//

import UIKit

class SigninViewController: UIViewController {
    
    @IBOutlet var usernameText: UITextField!
    @IBOutlet var passwordText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationItem.title = "Office Crime"
        self.navigationItem.rightBarButtonItem = .init(title: "Sign Up", style: .plain, target: self, action: #selector(signupAction(_:)))
    }
    
    
    @IBAction func signinAction(_ sender: UIButton) {
        
        if let username = usernameText.text, let password = passwordText.text,
           !username.isEmpty, !password.isEmpty{
            
            self.view.makeToastActivity(.center)
            appMgr.signin(username: username, password: password) { (success, error) in
                self.view.hideToastActivity()
                
                if success {
                    self.showDashboard()
                }
                else if let err = error {
                    self.showToast(err.errorDescription)
                }
                else {
                    self.showToast("Login failed.")
                }
            }
        }
        else  {
            self.showAlert(title: "Login Failed!",
                           message: "You can't login with empty username or password")
        }
    }
    
    @objc func signupAction(_ sender: UIButton) {
        performSegue(withIdentifier: "segue.signup", sender: self)
    }
    
    
    func showDashboard() {
        appRouter.gotoMain()
        
        if let user = appMgr.currentUser {
            self.navigationController?.showAlert(title: "Login Successful!", message: "Hello, \(user.nickname)")
        }
    }
}

