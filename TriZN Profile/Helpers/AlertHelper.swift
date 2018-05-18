//
//  AlertHelper.swift
//  TriZN Profile
//
//  Created by Tri ZN on 4/2/18.
//  Copyright © 2018 Tri ZN. All rights reserved.
//

import UIKit

class AlertHelper: NSObject {
    static let bounds = UIScreen.main.bounds
    
    static func showAlert(sender: UIViewController, title: String, message: String?) {
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction.init(title: "OK", style: .default, handler: nil)
        alert.addAction(okButton)
        sender.present(sender, animated: true, completion: nil)
    }
}
