//
//  AuthenticationViewController.swift
//  TriZN Profile
//
//  Created by Tri ZN on 4/4/18.
//  Copyright © 2018 Tri ZN. All rights reserved.
//

import UIKit
import FlickrKit

class AuthenticationViewController: UIViewController {

    // MARK : Properties
    @IBOutlet weak var loginWebView: UIWebView!
    private var userViewModel = UserViewModel.init()
    
    var helperFlickr: FlickrHelper?
    
    // MARK: View cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(true)
        
        // webview load request
        
        if let request = userViewModel.urlRequest {
            self.loginWebView.loadRequest(request)
        } 
        
    }
}

// MARK: - Extension UIWebViewDelegae
extension AuthenticationViewController: UIWebViewDelegate {
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        userViewModel.checkAuth(with: request, completionHandler: { (result) in
            if result {
                let storyboad = UIStoryboard(name: "Skill", bundle: nil)
                let galleryVC = storyboad.instantiateViewController(withIdentifier: "IdentifyGalleryViewController")
                self.navigationController?.setViewControllers([galleryVC], animated: true)
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4, execute: {
                    _ = self.navigationController?.popToRootViewController(animated: true)
                })
            }
        })

        return true
    }
}

