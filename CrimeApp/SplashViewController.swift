//
//  SplashViewController.swift
//  CrimeApp
//
//  Created by lucas on 5/4/2021.
//  Copyright © 2021 lucas. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
            self.gotoMain()
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func gotoMain() {
        performSegue(withIdentifier: "splash.main", sender: self)
    }
}
