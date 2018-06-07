//
//  ImagePreviewViewController.swift
//  TriZN Profile
//
//  Created by Tri ZN on 4/18/18.
//  Copyright © 2018 Tri ZN. All rights reserved.
//

import UIKit

class ImagePreviewViewController: UIViewController, UIGestureRecognizerDelegate {

    // MARK: - Properties
    // Get the URL which needs to be show
    var getURL: Photo?
    
    // Get image
    var image: UIImage? = nil
    
    // Is hide navi and tabbar
    private var _isHidden = true
    
    // Outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set image from Flickr
        if let URL = self.getURL {
            activityIndicator.startAnimating()
            imageView.setImage(with: URL.imageURL, placeholder: nil, transformer: nil, progress: nil, completion: { (image) in
                    self.activityIndicator.stopAnimating()
                if image != nil {
                    self.image = image?.images?.first
                    self.activityIndicator.hidesWhenStopped = true
                } else {
                    return
                }
            })
        } else if let image = image {
            self.activityIndicator.stopAnimating()
            self.imageView.image = image
            self.activityIndicator.stopAnimating()
            self.activityIndicator.hidesWhenStopped = true
        }
        configureSubviews()
    }
    

    
    // MARK: - Private methods
    private func configureSubviews() {
        
        //Add gesture recognizer in imageview
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.hideNavigationAndTabbar(gestureRecognizer:)))
        tapGestureRecognizer.delegate = self
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizer)
        
    }
    
    @objc func hideNavigationAndTabbar(gestureRecognizer: UIGestureRecognizer) {
        if _isHidden {
            view.backgroundColor = UIColor.black
            
        } else {
            view.backgroundColor = UIColor.white
        }
        navigationController?.navigationBar.isHidden = _isHidden
        tabBarController?.tabBar.isHidden = _isHidden
        _isHidden = !_isHidden
        
    }
    
    // Button Actions
    @IBAction func tappedCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }


}
