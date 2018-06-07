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
    
    var helperFlickr: FlickrHelper?
    
    // MARK: View cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false

    }
    
    override func viewWillAppear(_ animated: Bool) {
        auth()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
    }
    
    // MARK: - Private Methods

    /*
    * For calling the Flickr in webview
    *
    */
    private func auth() {
        let callbackURLString = "triznprofile://auth"
        guard let url = URL(string: callbackURLString) else {
            return
        }
        FlickrKit.shared().beginAuth(withCallbackURL: url,
                                     permission: FKPermission.delete,
                                     completion: { (url, error) in
                                        DispatchQueue.main.async(execute: { () in
                                            if error == nil {
                                                let urlRequest = NSMutableURLRequest.init(url: url!,
                                                                                          cachePolicy: NSURLRequest.CachePolicy.useProtocolCachePolicy,
                                                                                          timeoutInterval: 30)
                                                self.loginWebView.loadRequest(urlRequest as URLRequest)
                                            } else {
                                                guard let message = error?.localizedDescription else {
                                                    return
                                                }
                                                self.view.makeToast("\(message)")
                                            }
                                        })
        })
        
    }

}

// MARK: - Extension UIWebViewDelegae
extension AuthenticationViewController: UIWebViewDelegate {
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        let url = request.url
        let schema = url?.scheme
        if schema == "triznprofile" {
            if let token = url {
                User.share().saveAccessToken(url: token)
                
//                let storyboad = UIStoryboard(name: "Skill", bundle: nil)
//                let galleryVC = storyboad.instantiateViewController(withIdentifier: "IdentifyGalleryViewController")
//                self.navigationController?.setViewControllers([galleryVC], animated: true)

                self.helperFlickr = FlickrHelper()
                self.helperFlickr?.checkAuthentication(callbackURL: token, sender: self, { (error) in
                    // Push to Gallery View Controller
                    if error == nil {
                                        let storyboad = UIStoryboard(name: "Skill", bundle: nil)
                                        let galleryVC = storyboad.instantiateViewController(withIdentifier: "IdentifyGalleryViewController")
                                        self.navigationController?.setViewControllers([galleryVC], animated: true)
//                        _ = self.navigationController?.popViewController(animated: true)
                    } else {
                        print("ashdjkas")
                    }
       
                })
                
            } else if url?.absoluteString == "https://m.flickr.com/#/home" {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4, execute: {
                    _ = self.navigationController?.popToRootViewController(animated: true)
                })
            }
        }
        
        return true
    }
}

