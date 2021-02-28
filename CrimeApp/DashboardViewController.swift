//
//  DashboardViewController.swift
//  CrimeApp
//
//  Created by lucas on 10/31/20.
//  Copyright © 2020 lucas. All rights reserved.
//

import UIKit
import FirebaseFirestore

class DashboardViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    
    var localCollection: LocalCollection<EventModel>!

    fileprivate func baseQuery() -> Query {
        return Firestore.firestore().collection(EventModel.CollectionName)
            .order(by: "updateTime", descending: true)
            .limit(to: 50)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "Dashboard"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(onAdd(_:)))
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.tableView.rowHeight = 60
        self.tableView.estimatedRowHeight = 60
        
        localCollection = LocalCollection(query: baseQuery()) { [unowned self] (changes) in
  
            var indexPaths: [IndexPath] = []
            // Only care about additions in this block, updating existing reviews probably not important
            // as there's no way to edit reviews.
            for addition in changes.filter({ $0.type == .added }) {
                let index = self.localCollection.index(of: addition.document)!
                let indexPath = IndexPath(row: index, section: 0)
                indexPaths.append(indexPath)
            }
            
            var rmIndexPaths: [IndexPath] = []
            for addition in changes.filter({ $0.type == .removed }) {
                let index: Int = Int(addition.oldIndex)
                let indexPath = IndexPath(row: index, section: 0)
                rmIndexPaths.append(indexPath)
            }
            
            self.tableView.performBatchUpdates {
                self.tableView.insertRows(at: indexPaths, with: .automatic)
                self.tableView.deleteRows(at: rmIndexPaths, with: .left)
            } completion: { (ok) in
                
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        localCollection.listen()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    
    deinit {
        localCollection.stopListening()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segue.event.detail", let indexPath = sender as? IndexPath {
            let nextVC = segue.destination as! EventDetailViewController
            nextVC.event = self.localCollection[indexPath.row]
        }
    }
    
    @objc func onAdd(_ sender: Any?) {
        self.performSegue(withIdentifier: "segue.event.new", sender: nil)
    }
}

extension DashboardViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.localCollection.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: EventItemCell = tableView.dequeueReusableCell(withIdentifier: "EventItemCell") as! EventItemCell
        
        let model = self.localCollection[indexPath.row]
        
        cell.update(model: model)
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        // Show event details.
        performSegue(withIdentifier: "segue.event.detail", sender: indexPath)
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: UIContextualAction.Style.normal, title: "Delete", handler: {(contextualAction, view, boolValue) in
            
            let document = self.localCollection.documents[indexPath.row]
            EntityManager.shared.delete(event: document.documentID)
        })
        
        deleteAction.backgroundColor = .red
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
