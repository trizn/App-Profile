//
//  SkillViewController.swift
//  TriZN Profile
//
//  Created by Tri ZN on 3/26/18.
//  Copyright © 2018 Tri ZN. All rights reserved.
//

import UIKit
import FlickrKit

class SkillViewController: UIViewController {

    // MARK: - Properties
    var skillCollectionView: UICollectionView!
    var skillTableView = UITableView()
    var loginWebView = UIWebView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        configureSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        auth()
    }
    
    // MARK: - Private Method
    
    /*
     configure subviews.
    */
    private func configureSubviews() {
        var rect = CGRect.zero
        rect.size.width = DEVICE_WIDTH
        rect.size.height = DEVICE_HEIGHT - (navigationController?.navigationBar.frame.size.height)!
        rect.origin.x = 0
        rect.origin.y = (navigationController?.navigationBar.frame.size.height)!
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 20, height: 20)
        
        
        skillCollectionView = UICollectionView.init(frame: rect, collectionViewLayout: layout)
//        skillCollectionView = UICollectionView.init(frame: rect)
        view.addSubview(skillCollectionView)
        skillCollectionView.register(UINib.init(nibName: "ItemCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        skillCollectionView.backgroundColor = UIColor.blue
        
        skillCollectionView.delegate = self
        skillCollectionView.dataSource = self
        
        skillCollectionView.isHidden = true

        loginWebView = UIWebView(frame: rect)
        view.addSubview(loginWebView)
        loginWebView.delegate = self
    }
    
    private func auth() {
        let callbackURLString = "triznprofile://auth"
        guard let url = URL.init(string: callbackURLString) else {
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
                    AlertHelper.showAlert(sender: self, title: "Error", message: message)
                }
            })
        })
        
    }

}

// MARK: - Extension UICollectionViewDataSource
extension SkillViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 50
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: UICollectionViewCell = (collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath as IndexPath) as? UICollectionViewCell)!
        cell.backgroundColor = UIColor.red
        return cell
    }

}

extension SkillViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberItemInLine: CGFloat = 5.0
        
        let cellSizeWidth = DEVICE_WIDTH / numberItemInLine
        let cellSizeHeight = cellSizeWidth
        return CGSize.init(width: cellSizeWidth, height: cellSizeHeight)
    }

}

extension SkillViewController: UIWebViewDelegate {
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        let url = request.url
        let schema = url?.scheme
        if schema == "triznprofile" {
            if let token = url {
                User.share().saveAccessToken(url: token)
//                HelperFlickr.checkAuthentication(callbackURL: token, sender: self, { () -> Void? in
                   _ = self.navigationController?.popToRootViewController(animated: true)
//                })
            } else if url?.absoluteString == "https://m.flickr.com/#/home" {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4, execute: {
                    _ = self.navigationController?.popToRootViewController(animated: true)
                })
            }
        }
        
        return true
    }

}
