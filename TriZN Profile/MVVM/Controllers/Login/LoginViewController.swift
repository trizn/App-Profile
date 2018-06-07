//
//  LoginViewController.swift
//  TriZN Profile
//
//  Created by Tri ZN on 4/3/18.
//  Copyright © 2018 Tri ZN. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    
    override func loadView() {
        super.loadView()
        if User.share().accessToken != nil {
            let storyboad = UIStoryboard(name: "Skill", bundle: nil)
            let galleryVC = storyboad.instantiateViewController(withIdentifier: "IdentifyGalleryViewController")
            
            self.navigationController?.pushViewController(galleryVC, animated: true)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }

}
