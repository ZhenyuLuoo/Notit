//
//  EventDetailViewController.swift
//  CrimeApp
//
//  Created by lucas on 10/31/20.
//  Copyright © 2020 lucas. All rights reserved.
//

import UIKit
import SDWebImage
import FirebaseFirestore

class EventDetailViewController: UIViewController {
    
    @IBOutlet var detailImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var contentText: UILabel!
    @IBOutlet weak var imageHeightCons: NSLayoutConstraint!
    @IBOutlet weak var editCommentField: UITextField!
    
    var event: EventModel?
    var localCollection: LocalCollection<CommentModel>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 44

        self.editCommentField.delegate = self
        
        self.update()
        
        localCollection = LocalCollection(query: baseQuery()) { [unowned self] (changes) in
            self.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.localCollection.listen()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.update()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        localCollection.stopListening()
    }
    
    deinit {
        self.localCollection.stopListening()
    }
    
    fileprivate func baseQuery() -> Query {
        return Firestore.firestore().collection(CommentModel.CollectionName)
            .whereField("eventId", isEqualTo: self.event?.uuid ?? "")
            .order(by: "updateTime", descending: true)
            .limit(to: 50)
    }
    
    func update() {
        self.navigationItem.title = event?.title
        if let imageName = event?.imageName {
            let imgRef = EntityManager.shared.imageRef(imgName: imageName)
            self.detailImage.sd_setImage(with: imgRef)
        }

        self.titleText.text = event?.title
        self.contentText.text = event?.content
        
        if self.detailImage.image == nil {
            self.imageHeightCons.constant = 0
        }
        else {
            self.imageHeightCons.constant = 240
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segue.comment.new" {
            let nextVC = segue.destination as! AddCommentViewController
            nextVC.event = self.event
        }
    }
}

extension EventDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.localCollection.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "CommentItemCell")
        
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "CommentItemCell")
            cell?.textLabel?.font = .systemFont(ofSize: 12)
            cell?.textLabel?.numberOfLines = 0
            cell?.detailTextLabel?.font = .systemFont(ofSize: 11)
            cell?.detailTextLabel?.textColor = .gray
        }
        
        let entity = self.localCollection[indexPath.row]
        cell!.textLabel?.text = entity.content
        cell!.detailTextLabel?.text = "by \(entity.ownerName ), \(entity.createTime)"
        cell!.selectionStyle = .none
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: UIContextualAction.Style.normal, title: "Delete", handler: {(contextualAction, view, boolValue) in
            let document = self.localCollection.documents[indexPath.row]
            
            self.view.makeToastActivity(.center)
            EntityManager.shared.delete(comment: document.documentID) {  [weak self] _,_ in
                self?.view.hideToastActivity()
            }
        })
        
        deleteAction.backgroundColor = .red
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

extension EventDetailViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.performSegue(withIdentifier: "segue.comment.new", sender: nil)
        return false
    }
}
