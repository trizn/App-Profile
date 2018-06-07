//
//  HelperFlickr.swift
//  TriZN Profile
//
//  Created by Tri ZN on 4/2/18.
//  Copyright © 2018 Tri ZN. All rights reserved.
//

import UIKit
import FlickrKit

class FlickrHelper {
    var completeAuthOp: FKDUNetworkOperation!
    var checkAuthOp: FKDUNetworkOperation!

    //For authentication User
    func checkAuthentication(callbackURL: URL, sender: UIViewController, _ completionHandle: @escaping (Error?) -> Void) {
            self.completeAuthOp = FlickrKit.shared().completeAuth(with: callbackURL, completion: {
                (userName, userID, fullName, error) -> Void in
                DispatchQueue.main.sync(execute: { () -> Void in
                    if error == nil {
                        UserModel.share().setProfileInfo(userName: userName, fullName: fullName, userId: userID)
                        completionHandle(nil)
                    } else {
                        guard let message = error?.localizedDescription else {
                            return
                        }
    //                    HelperAlert.showAlert(sender: sender, title: "Sorry", message: message)
                        sender.view.makeToast(message)
                        completionHandle(error)
                    }
                })
            })
    }
    
    // Call once the User is logged in after authentiction
    func login(sender: UIViewController, _ completionHandle: @escaping (_ error: Error?) -> Void) {
        self.checkAuthOp = FlickrKit.shared().checkAuthorization {
            (userName, userID, fullName, error) in
            if error == nil {
                UserModel.share().setProfileInfo(userName: userName, fullName: fullName, userId: userID)
                
                completionHandle(nil)
                
            } else {
                guard let message = error?.localizedDescription else {
                    return
                }
                
                if message.contains("There isn't a stored token to check. Login first.") {
                    UserModel.userDefaults.removeObject(forKey: UserModel.tokenKey)
                }
                
                completionHandle(error)
                
            }
        }
    }
}
