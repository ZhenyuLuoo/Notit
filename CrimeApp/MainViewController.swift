//
//  MainViewController.swift
//  CrimeApp
//
//  Created by lucas on 2021/3/17.
//  Copyright © 2021 lucas. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.delegate = self
        
        
        if let firstVc = self.viewControllers?.first {
            self.updateNavigationBar(firstVc)
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
    
    
    fileprivate func updateNavigationBar(_ viewController: UIViewController) {
        self.navigationItem.title = viewController.navigationItem.title
        self.navigationItem.rightBarButtonItems = viewController.navigationItem.rightBarButtonItems
    }

}

extension MainViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        self.updateNavigationBar(viewController)
    }
}
