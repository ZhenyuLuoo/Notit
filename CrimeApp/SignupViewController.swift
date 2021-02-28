//
//  SignupViewController.swift
//  CrimeApp
//
//  Created by lucas on 10/31/20.
//  Copyright © 2020 lucas. All rights reserved.
//

import UIKit
import Toast_Swift

class SignupViewController: UIViewController {
    
    @IBOutlet var usernameText: UITextField!
    @IBOutlet var passwordText: UITextField!
    @IBOutlet var confirmText: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "Sign Up"
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func Register(_ sender: UIButton) {

        if let username = usernameText.text, let password = passwordText.text, let confirmPswd = confirmText.text, !username.isEmpty, !password.isEmpty, !confirmPswd.isEmpty {
            
            if password != confirmPswd{
                self.showAlert(title: "The passwords are not the same!", message: "Make sure you entered the same password")
            }
            else {
                let username = usernameText.text!
                let password = passwordText.text!
                
                self.view.makeToastActivity(.center)
                EntityManager.shared.signup(username: username, password: password, nickname: username) { (success, error) in
                    self.view.hideToastActivity()
                    
                    if success {
                        self.showToast("Register completed.")
                        self.navigationController?.popViewController(animated: true)
                    }
                    else if let err = error {
                        self.showToast(err.localizedDescription)
                    }
                    else {
                        self.showToast("Register failed.")
                    }
                }
            }
        }
        else {
            self.showAlert(title: "Register failed!", message: "You can't register with an empty username or password")
        }
    }
}
