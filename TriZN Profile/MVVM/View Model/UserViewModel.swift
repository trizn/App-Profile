//
//  PhotoViewModel.swift
//  TriZN Profile
//
//  Created by Tri ZN on 5/28/18.
//  Copyright © 2018 Tri ZN. All rights reserved.
//

import Foundation



class UserViewModel {
    private var userModel: UserModel?
    
    var urlRequest: URLRequest?
    let services = PhotoServices()
    
    required init() {
        self.urlRequest = services.auth()
    }
    
    
    func checkAuth(with requestURL: URLRequest, completionHandler: @escaping (Bool) -> Void) {
        let url = requestURL.url
        let schema = url?.scheme
        if schema == "triznprofile" {
            if let token = url {
                UserModel.share().saveAccessToken(url: token)
                services.checkAuthentication(callbackURL: token, response: { (error) in
                    // Push to Gallery View Controller
                    if error == nil {
//                        let storyboad = UIStoryboard(name: "Skill", bundle: nil)
//                        let galleryVC = storyboad.instantiateViewController(withIdentifier: "IdentifyGalleryViewController")
//                        viewController.navigationController?.setViewControllers([galleryVC], animated: true)
                        completionHandler(true)
                    }
                })
                
            } else if url?.absoluteString == "https://m.flickr.com/#/home" {
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4, execute: {
//                    _ = viewController.navigationController?.popToRootViewController(animated: true)
//                })
                completionHandler(false)
            }
        }
    }
    
    
    
}
