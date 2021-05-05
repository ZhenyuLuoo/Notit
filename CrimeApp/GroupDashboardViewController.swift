//
//  GroupDashboardViewController.swift
//  CrimeApp
//
//  Created by lucas on 2021/3/17.
//  Copyright © 2021 lucas. All rights reserved.
//

import UIKit
import SwifterSwift

class GroupDashboardViewController: UIViewController {
    enum MenuType {
        case events, members
    }
    
    var groupModel: GroupModel?
    
    private var eventsVC: GroupEventsViewController?
    private var membersVC: GroupMembersViewController?
    private var menuType: MenuType = .events
    
    @IBOutlet weak var btnMembers: UIButton!
    @IBOutlet weak var btnEvents: UIButton!
    @IBOutlet weak var containerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navigationItem.title = groupModel?.name
        
        let  selectedImage = UIImage(named: "ic_btn_bg")
        self.btnEvents.setBackgroundImage(selectedImage, for: .selected)
        self.btnMembers.setBackgroundImage(selectedImage, for: .selected)
        
        if let vc = self.storyboard?.instantiateViewController(identifier: "GroupEventsViewController") as? GroupEventsViewController {
            self.eventsVC = vc
            vc.groupModel = self.groupModel
            self.addChildViewController(vc, toContainerView: self.containerView)
            vc.view.isHidden = true
        }
        
        if let vc = self.storyboard?.instantiateViewController(identifier: "GroupMembersViewController") as? GroupMembersViewController {
            self.membersVC = vc
            vc.groupModel = self.groupModel
            self.addChildViewController(vc, toContainerView: self.containerView)
            vc.view.isHidden = true
        }
        self.updateButtons(type: .events)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.eventsVC?.view.frame = self.containerView.bounds
        self.membersVC?.view.frame = self.containerView.bounds
    }

    @IBAction func onAddAction(_ sender: Any) {
       
    }
    
    @IBAction func onQuite(_ sender: Any) {
        guard let me = appMgr.currentUser?.uuid,
              let groupId = self.groupModel?.uuid,
              let ownerId = self.groupModel?.ownerId else {
            return
        }
        
        if me == ownerId {
            self.showAlert(title: "Dissolve this group?",
                           message: "You are the owner of this group, are you sure to dissolve it?",
                           actionsText: ["Ok", "Cancel"]) { index in
                if index == 0 {
                    // Ok
                    DispatchQueue.main.async {
                        appDB.delete(groupId: groupId) { (error) in
                            self.navigationController?.popViewController()
                        }
                    }
                   
                }
            }
        }
        else {
            self.showAlert(title: "Quit this group?",
                           message: "Are you sure to quit this group?",
                           actionsText: ["Ok", "Cancel"]) { index in
                if index == 0 {
                    // Ok
                    DispatchQueue.main.async {
                        appDB.updateGroup(groupId: groupId, rmMembers: [me]) { (error) in
                            self.navigationController?.popViewController()
                        }
                    }
                }
            }
        }

        
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
    @IBAction func onEventClicked(_ sender: Any) {
        self.updateButtons(type: .events)
    }
    
    @IBAction func onMemberClicked(_ sender: Any) {
        self.updateButtons(type: .members)
    }
    
    private func updateButtons(type: MenuType) {
        self.menuType = type
        self.btnEvents.isSelected = (type == .events)
        self.btnMembers.isSelected = (type == .members)
        self.eventsVC?.view.isHidden = !self.btnEvents.isSelected
        self.membersVC?.view.isHidden = !self.btnMembers.isSelected
        
        switch type {
        case .events:
            self.navigationItem.rightBarButtonItems = self.eventsVC?.navigationItem.rightBarButtonItems
        
        case .members:
            self.navigationItem.rightBarButtonItems = self.membersVC?.navigationItem.rightBarButtonItems
        }
    }
}
