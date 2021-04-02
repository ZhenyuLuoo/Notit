//
//  RouterManager.swift
//  CrimeApp
//
//  Created by lucas on 2021/3/17.
//  Copyright © 2021 lucas. All rights reserved.
//

import Foundation
import UIKit

let appRouter = RouterManager.shared

class RouterManager {
    static let shared = RouterManager()
    
    private init () {}
    private lazy var storyboard: UIStoryboard = {
        UIStoryboard(name: "Main", bundle: nil)
    }()
    
    func gotoMain() {
        guard let nav = self.rootNavigator else {
            return
        }
        
        if let vc = self.storyboard.instantiateViewController(identifier: "MainViewController") as? MainViewController {
            nav.setViewControllers([vc], animated: true)
        }
    }
    
    func gotoLogin() {
        guard let nav = self.rootNavigator else {
            return
        }
        
        if let vc = self.storyboard.instantiateViewController(identifier: "SigninViewController") as? SigninViewController {
            
            // to use the pop animation when set view controllers.
            nav.viewControllers.insert(vc, at: 0)
            
            // replace the view controllers.
            nav.setViewControllers([vc], animated: true)
        }
    }
    
    func gotoDashboard() {
        guard let nav = self.rootNavigator else {
            return
        }
        
        if let vc = self.storyboard.instantiateViewController(identifier: "GroupEventsViewController") as? GroupEventsViewController {
            nav.setViewControllers([vc], animated: true)
        }
    }
    
    private var rootNavigator: UINavigationController? {
        let window = UIApplication.shared.windows.first
        let nvCtrl = window?.rootViewController as? UINavigationController
        return nvCtrl
    }
}
