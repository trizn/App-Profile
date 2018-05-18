//
//  AvatarTableViewCell.swift
//  TriZN Profile
//
//  Created by Tri ZN on 3/24/18.
//  Copyright © 2018 Tri ZN. All rights reserved.
//

import UIKit

class AvatarTableViewCell: UITableViewCell {

    @IBOutlet weak var avatarImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureSubview()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
//    override func layoutIfNeeded() {
//        avatarImage.clipsToBounds = true
//        avatarImage.layer.cornerRadius = self.avatarImage.bounds.height / 2
//    }
//
//    override func layoutSubviews() {
//        super.layoutSubviews()
//
//
//    }
    
    func configureSubview() {
        avatarImage.layer.masksToBounds = false
        avatarImage.clipsToBounds = true
        avatarImage.layer.cornerRadius = avatarImage.bounds.width / 2
        
    }
    
    
}
