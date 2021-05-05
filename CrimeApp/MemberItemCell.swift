//
//  MemberItemCell.swift
//  CrimeApp
//
//  Created by lucas on 2021/3/17.
//  Copyright © 2021 lucas. All rights reserved.
//

import UIKit
import SDWebImage

class MemberItemCell: UITableViewCell {

    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var labNickname: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.imgAvatar.layer.cornerRadius = self.imgAvatar.bounds.width / 2
        self.imgAvatar.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func update(model: UserModel) {
        self.labNickname.text = model.nickname
        let defaultImg = UIImage(named: "ic_user_avatar")
        
        if let imageName = model.avatar {
            let imgRef = appStorage.imageRef(imgName: imageName)
            self.imgAvatar.sd_setImage(with: imgRef, placeholderImage: defaultImg)
        }
        else {
            self.imgAvatar.image = defaultImg
        }
    }
}
