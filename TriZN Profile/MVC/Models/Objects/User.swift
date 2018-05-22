//
//  User.swift
//  TriZN Profile
//
//  Created by Tri ZN on 3/30/18.
//  Copyright © 2018 Tri ZN. All rights reserved.
//

import UIKit

class User: NSObject {
    static private var singleton: User?
    
    var userName: String?
    var name: String?
    var userId: String?
    var accessToken: URL? {
        get {
            let token = User.userDefaults.url(forKey: User.tokenKey)
            return token
        }
    }
    
    //UserDefaults for saving token
    static var userDefaults = UserDefaults()
    // Key for accessing/saving token
    static var tokenKey = "accessToken"
    
    // MARK: - Init Singleton
    static func share() -> User {
        guard let uwShared = singleton else {
            singleton = User()
            return singleton!
        }
        return uwShared
    }
    
    // denit
    static func destroy() {
        self.userDefaults.removeObject(forKey: self.tokenKey)
        singleton = nil
    }
    
    //Sets User data to singleton object
    func setProfileInfo(userName: String?, fullName: String?, userId: String?) {
        self.userName = userName
        self.name = fullName
        self.userId = userId
    }
    
    // Saving access token in user defaults
    func saveAccessToken(url: URL) {
        let token = User.userDefaults.value(forKey: User.tokenKey)
        
        if token == nil {
            User.userDefaults.set(url, forKey: User.tokenKey)
        }
    }
}
