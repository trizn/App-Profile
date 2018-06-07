//
//  ItemCollectionViewCell.swift
//  TriZN Profile
//
//  Created by Tri ZN on 3/26/18.
//  Copyright © 2018 Tri ZN. All rights reserved.
//

import UIKit
import MapleBacon

class GalleryCell: UICollectionViewCell {

    //MARK: - Properties
    static let identifier = "GalleryCell"
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var photoURL : Photo? {
        didSet {
            DispatchQueue.main.async(execute: {
                if let URL = self.photoURL?.imageURL {
                    self.activityIndicator.startAnimating()
//                    self.imageView.setImage(with: URL)
                    self.imageView.setImage(with: URL as URL?, placeholder: nil, transformer: nil, progress: nil, completion: { (image) in
                            self.activityIndicator.stopAnimating()
//                            self.activityIndicator.removeFromSuperview()
                        self.activityIndicator.hidesWhenStopped = true
                    })
                    
                }
            })
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
