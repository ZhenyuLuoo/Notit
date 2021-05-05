//
//  GroupMembersViewController.swift
//  CrimeApp
//
//  Created by lucas on 2021/3/17.
//  Copyright © 2021 lucas. All rights reserved.
//

import UIKit

class GroupMembersViewController: UITableViewController {
    
    var groupModel: GroupModel?
    var members: [UserModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        self.navigationItem.title = "Members"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.reloadMembers()
    }
    
    func reloadMembers() {
        guard let gm = groupModel else {
            return
        }
        
        appDB.retrieveMembers(of: gm) { (result) in
            switch result {
            case .success(let models):
                self.members = models
                break
            case .failure(let error):
                break
            }
            
            self.refreshControl?.endRefreshing()
            self.tableView.reloadData()
        }
    }
    
    @IBAction func onRefreshTriggered(_ sender: Any) {
        self.reloadMembers()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return members.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemberItemCell", for: indexPath)

        // Configure the cell...
        if let memberCell = cell as? MemberItemCell {
            let model = members[indexPath.row]
            memberCell.update(model: model)
    
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

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "segue.group.addmember" {
            if let vc = segue.destination as? GroupMemberPickerController {
                vc.groupModel = self.groupModel
            }
        }
    }
}
