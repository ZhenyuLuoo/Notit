//
//  GroupMemberPickerController.swift
//  CrimeApp
//
//  Created by lucas on 2021/3/18.
//  Copyright © 2021 lucas. All rights reserved.
//

import UIKit

class GroupMemberPickerController: UITableViewController {
    
    private var allUsers: [UserModel] = []
    private var seletctUsers: [UserModel] = []
    private var searchResultUsers: [UserModel] = []
    private var pickerUsers: Set<String> = []
    
    private var users: [UserModel] {
        return self.searchResultUsers
    }
    
    var groupModel: GroupModel?
    
    private lazy var searchController: UISearchController  = {
        let ctrl = UISearchController()
        ctrl.obscuresBackgroundDuringPresentation = false
        return ctrl
    }()

    private func updateSelectUsers() {
        self.seletctUsers = self.allUsers.filter { (model) -> Bool in
            self.pickerUsers.contains(model.username)
        }
    }
    
    private func updateSearchResultUsers(query: String) {
        if query.isEmpty {
            self.searchResultUsers = self.allUsers.filter { (model) -> Bool in
                self.pickerUsers.contains(model.username)
            }
        }
        else {
            self.searchResultUsers = self.allUsers.filter { (model) -> Bool in
                self.pickerUsers.contains(model.username) || model.nickname.contains(query, caseSensitive: false)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        self.navigationItem.title = "Add members"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(onDone(_:)))
        
        self.searchController.delegate = self
        self.searchController.searchResultsUpdater = self
        self.searchController.searchBar.delegate = self
        self.tableView.tableHeaderView = searchController.searchBar
        
        self.reloadUsers()
    }

    @objc func onDone(_ sender: Any?) {
        
        if self.pickerUsers.isEmpty {
            self.navigationController?.popViewController()
        }
        else if let groupdId = self.groupModel?.uuid {
            let addUserIds = Array(pickerUsers)
            appDB.updateGroup(groupId: groupdId, addMembers: addUserIds) {_ in
                
                addUserIds.forEach { (userId) in
                    self.groupModel?.members.insert(userId)
                }
                
                self.navigationController?.popViewController()
            }
        }
    }
    
    @IBAction func onRefreshingTriggered(_ sender: Any) {
        self.reloadUsers()
    }
    
    func reloadUsers() {
        appDB.retrieveUsers { (result) in
            switch result {
            case .success(let models):
                self.allUsers = models
                self.tableView.reloadData()
                break
            case .failure(let error):
                break
            }
            
            self.refreshControl?.endRefreshing()
        }
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.users.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemberItemCell", for: indexPath)

        // Configure the cell...
        if let memberCell = cell as? MemberItemCell {
            let model = users[indexPath.row]
            memberCell.update(model: model)
            
            if let userId = model.uuid,
               let members = self.groupModel?.members{
                
                let imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: 16, height: 16))
                
                if members.contains(userId) {
                    imgView.image = UIImage(named: "ic_check_gray")
                    memberCell.accessoryView = imgView
                }
                else if pickerUsers.contains(userId) {
                    imgView.image = UIImage(named: "ic_check_blue")
                    memberCell.accessoryView = imgView
                }
                else {
                    memberCell.accessoryView = nil
                }
            }
            
            memberCell.selectionStyle = .none
            
            if let ownerId = self.groupModel?.ownerId,
               let userId = model.uuid, ownerId == userId {
                memberCell.labNickname.font = .boldSystemFont(ofSize: 16)
            }
            else {
                memberCell.labNickname.font = .systemFont(ofSize: 16)
            }
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let userId = users[indexPath.row].uuid,
           let members = self.groupModel?.members,
           !members.contains(userId) {
            
            if pickerUsers.contains(userId) {
                pickerUsers.remove(userId)
            }
            else {
                pickerUsers.insert(userId)
            }
        }
        
        tableView.reloadRows(at: [indexPath], with: .none)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension GroupMemberPickerController: UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {

    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        guard let text = searchBar.text else { return }
        
        if text.isEmpty {
            self.updateSearchResultUsers(query: "")
        }
        else {
            self.updateSearchResultUsers(query: text)
        }
        
        self.tableView.reloadData()
        
        self.searchController.isActive = false
    }
}
