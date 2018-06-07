//
//  MainTabBarController.swift
//  TriZN Profile
//
//  Created by Tri ZN on 4/4/18.
//  Copyright © 2018 Tri ZN. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    // MARK: - Properties
    var destinationViewController: UIViewController?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        delegate = self
        
        var storyboard = UIStoryboard()
        var identifier: String = ""
        
        if(UserModel.share().accessToken != nil) {
            storyboard = UIStoryboard(name: "Skill", bundle: nil)
//            identifier = "IdentifyGalleryViewController"
            identifier = "InitialSkill"
        } else {
            storyboard = UIStoryboard(name: "Login", bundle: nil)
//            identifier = "IdentifyLoginViewController"
            identifier = "InitialLogin"
        }
        
        destinationViewController = storyboard.instantiateViewController(withIdentifier: identifier)
        if var viewcontrollers = self.viewControllers {
            viewcontrollers[1] = destinationViewController!
            self.viewControllers = viewcontrollers
        }
        
    }
    
    override func loadView() {
        super.loadView()
        
        
        
    
    }


}

extension MainTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {

//        // Tabbar item skill = 1
//        if tabBarController.selectedIndex == 1 {
//            
//            if let vc = destinationViewController {
//                
//            }
//            
//        }
        
    }
    
}
