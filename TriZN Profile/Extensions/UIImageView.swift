//
//  UIImageView.swift
//  TriZN Profile
//
//  Created by Tri ZN on 3/2/18.
//  Copyright © 2018 Tri ZN. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    func blurImage() {
        let blurEffect = UIBlurEffect.init(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView.init(effect: blurEffect)
        
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.addSubview(blurEffectView)
    }
}
