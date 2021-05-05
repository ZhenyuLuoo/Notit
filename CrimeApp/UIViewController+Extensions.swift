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
    
    func showAlert(title: String, message: String?, actionsText: [String] = ["OK"], preferredStyle: UIAlertController.Style = .alert, handler: ((Int) -> Void)? = nil) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        
        var index = 0
        for text in actionsText {
            let actionIndex = index
            let action = UIAlertAction(title: text, style: .default) { (_) in
                handler?(actionIndex)
            }
            alert.addAction(action)
            
            index += 1
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func showToast(_ msg: String) {
        self.view.makeToast(msg, duration:1.5 ,position: .center)
    }
    
    func showInputAlert(title: String, message: String?, text: String = "",
                        inputPlaceholder: String = "", actionsText: [String] = ["OK"],
                        handler: ((Int, String?) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addTextField(text: text, placeholder: inputPlaceholder, editingChangedTarget: nil, editingChangedSelector: nil)
        
        var index = 0
        for text in actionsText {
            let action = UIAlertAction(title: text, style: .default) { (_) in
                let inputText = alert.textFields?.first?.text
                handler?(index, inputText)
            }
            alert.addAction(action)
            
            index += 1
        }
        
        alert.addAction(title: "Cancel", style: .cancel)
        
        self.present(alert, animated: true, completion: nil)
    }
}
