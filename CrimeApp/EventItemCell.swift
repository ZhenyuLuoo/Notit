//
//  EventItemCell.swift
//  CrimeApp
//
//  Created by lucas on 10/31/20.
//  Copyright © 2020 lucas. All rights reserved.
//

import UIKit
import SDWebImage
import FirebaseUI

class EventItemCell: UITableViewCell {
    
    @IBOutlet var mainLabel: UILabel!
    @IBOutlet var detailCell: UILabel!
    @IBOutlet var cellImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func update(model: EventModel) {
        self.mainLabel.text = model.title
        self.detailCell.text = model.content
        if let imgName = model.attachment {
            let imgRef = appStorage.imageRef(imgName: imgName)
            self.cellImage?.sd_setImage(with: imgRef)
        }
        else {
            self.cellImage.sd_cancelCurrentImageLoad()
            self.cellImage.image = nil
        }
    }
}
