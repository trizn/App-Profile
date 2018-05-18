//
//  SkillNavigationController.swift
//  TriZN Profile
//
//  Created by Tri ZN on 4/4/18.
//  Copyright © 2018 Tri ZN. All rights reserved.
//

import UIKit

class SkillNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        if(User.share().accessToken == nil) {
            if let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "IdentifyLoginViewController") {
                setViewControllers([loginVC], animated: true)
            }
        }
    }

}
