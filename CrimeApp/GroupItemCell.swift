//
//  GroupItemCell.swift
//  CrimeApp
//
//  Created by lucas on 2021/3/17.
//  Copyright © 2021 lucas. All rights reserved.
//

import UIKit

class GroupItemCell: UITableViewCell {

    @IBOutlet weak var labTitle: UILabel!
    @IBOutlet weak var labEventCount: UILabel!
    @IBOutlet weak var labMemberCount: UILabel!
    @IBOutlet weak var imgOwner: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization codes
        self.imgOwner.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func update(model: GroupModel) {
        self.labTitle.text = model.name
        
        let eventCount = model.eventCount
        self.labEventCount.text = "\(eventCount)"
        
        let memberCount = model.memberCount
        self.labMemberCount.text = "\(memberCount)"
        
        
        if let me = EntityManager.shared.currentUser?.uuid, me == model.ownerId {
            self.imgOwner.isHidden = false
        }
        else {
            self.imgOwner.isHidden = true
        }
    }
}
