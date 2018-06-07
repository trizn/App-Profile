//
//  InfomationTableViewCell.swift
//  TriZN Profile
//
//  Created by Tri ZN on 3/23/18.
//  Copyright © 2018 Tri ZN. All rights reserved.
//

import UIKit

class InfomationTableViewCell: UITableViewCell {

    // MARK: - Properties
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var viewCorner: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
     func setContent(withIcon image: UIImage?, textLabel: String?) {
        self.iconImage.image = image
        self.label.text = textLabel
        self.label.sizeToFit()
        self.label.numberOfLines = 0
//        self.label.adjustsFontSizeToFitWidth = true
//        self.label.adjustsFontForContentSizeCategory = true
        
        viewCorner.backgroundColor = UIColor.white
        viewCorner.layer.cornerRadius = 30.0
    }
    
}
