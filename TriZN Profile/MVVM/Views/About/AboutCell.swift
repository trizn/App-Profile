//
//  AboutCell.swift
//  TriZN Profile
//
//  Created by Tri ZN on 5/12/18.
//  Copyright © 2018 Tri ZN. All rights reserved.
//

import UIKit

class AboutCellContent {
    var heading: String?
    var body: String?
    var expended: Bool
    var line: Bool
    var color : UIColor
    
    
    init(heading: String, body: String, color: UIColor) {
        self.heading = heading
        self.body = body
        self.expended = false
        self.line = true
        self.color = color
    }
}

class AboutCell: UITableViewCell {

    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var lineCellView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func set(content: AboutCellContent) {
        self.headingLabel.text = content.heading
        self.bodyLabel.text = content.expended ? content.body : ""
        self.lineCellView.isHidden = content.line ? false : true
        
        self.lineCellView.backgroundColor = content.color
    }
    
}
