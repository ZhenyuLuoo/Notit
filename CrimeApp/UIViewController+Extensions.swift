//
//  UIViewController+Alert.swift
//  CrimeApp
//
//  Created by lucas on 2020/11/30.
//  Copyright © 2020 lucas. All rights reserved.
//

import Foundation
import UIKit
import CoreData

extension UIViewController {
    
    func showAlert(title: String, message: String?, actionsText: [String] = ["OK"], handler: ((Int) -> Void)? = nil) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        var index = 0
        for text in actionsText {
            let action = UIAlertAction(title: text, style: .default) { (_) in
                handler?(index)
            }
            alert.addAction(action)
            
            index += 1
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func showToast(_ msg: String) {
        self.view.makeToast(msg, duration:1.5 ,position: .center)
    }
}
