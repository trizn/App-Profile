//
//  ConstantsApp.swift
//  TriZN Profile
//
//  Created by Tri ZN on 3/2/18.
//  Copyright © 2018 Tri ZN. All rights reserved.
//

import Foundation
import UIKit

/*************************************************/

// MARK: Device Constants

let DEVICE_UUID     = UIDevice.current.identifierForVendor?.uuidString
let DEVICE_DELEGATE = UIApplication.shared.delegate as! AppDelegate
let DEVICE_WINDOW   = DEVICE_DELEGATE.window
let DEVICE_BOUNDS   = UIScreen.main.bounds
let DEVICE_WIDTH    = UIScreen.main.bounds.size.width
let DEVICE_HEIGHT   = UIScreen.main.bounds.size.height
let DISPLAY_SCALE   = DEVICE_WIDTH / 320.0

let VERSION         = Bundle.main.infoDictionary!["CFBundleVersion"]
let IS_WIDESCREEN   = DEVICE_HEIGHT >= 568.0
let IS_IPHONE       = (UIDevice.current.userInterfaceIdiom == .phone)

/*************************************************/

struct Constants {
    struct Information {
        static let name = "Vo Nhut Tri"
        static let avatar = "Avatar_TriZN.png"
        
        static let mail = "trizn610@gmail.com"
        static let iconMail = "icon_mail.png"
        
        static let mobile = "088.880.5623"
        static let iconMobile = "icon_mobile.png"
        
        static let chat = "votri1990"
        static let iconChat = "icon_chat.png"
        
        static let birthday = "Jun 10, 1990"
        static let iconBirthday = "icon_birthday.png"
        
        static let address = "No 477 Le Hong Phong street, district 10, HCM City"
        static let iconAddress = "icon_address.png"
        
        static let education = "Cao Thang Technical College"
        static let iconEducation = "icon_education.png"
    }
}
