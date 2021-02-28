//
//  AddCommentViewController.swift
//  CrimeApp
//
//  Created by lucas on 11/7/20.
//  Copyright © 2020 lucas. All rights reserved.
//

import UIKit

class AddCommentViewController: UIViewController {
    
    @IBOutlet var commentText: UITextField!
    var callback: ((String) -> Void)?
    var comment = ""
    var event: EventModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "Add Comment"
        self.navigationItem.rightBarButtonItem = .init(title: "Submit", style: .plain, target: self, action: #selector(submitComment(_:)))
    
        self.commentText.becomeFirstResponder()
    }
    
    @IBAction func submitComment(_ sender: UIButton) {
        guard let comment = commentText.text, let e = self.event, !comment.isEmpty else {
            self.showAlert(title: "Add Failed!",
                           message: "You can't submit with empty comment.")
            return
        }
        
        _ = EntityManager.shared.addComment(content: comment, to: e)
        self.showAlert(title: "Comment Success!", message: "Thanks for comment!") { (_) in
            self.navigationController?.popViewController(animated: true)
        }
    }
}
