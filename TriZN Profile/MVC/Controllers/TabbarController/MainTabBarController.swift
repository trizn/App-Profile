//
//  MainTabBarController.swift
//  TriZN Profile
//
//  Created by Tri ZN on 4/4/18.
//  Copyright © 2018 Tri ZN. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        delegate = self
    }

}

extension MainTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let storyboard = UIStoryboard(name: "Skill", bundle: nil)
        
        if(User.share().accessToken != nil) {
            let identifier = "IdentifyGalleryViewController"
            let galleryVC = storyboard.instantiateViewController(withIdentifier: identifier)
            navigationController?.setViewControllers([galleryVC], animated: true)
            
        }
        
        
        // Tabbar item about = 2
        if tabBarController.selectedIndex == 2 {
            
        }
        
    }
}
