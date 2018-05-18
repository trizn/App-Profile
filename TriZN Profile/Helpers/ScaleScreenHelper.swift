////
////  HelperScaleScreen.swift
////  TriZN Profile
////
////  Created by Tri ZN on 3/2/18.
////  Copyright © 2018 Tri ZN. All rights reserved.
////
//
//import Foundation
//import UIKit
//
//class Helper: NSObject  {
//    static func fontWithDisplayScale(font: UIFont) -> UIFont {
//        return font.withSize(font.pointSize * DISPLAY_SCALE)
//    }
//    
//    static func viewWithDisplayScale(view: UIView) {
//        view.translatesAutoresizingMaskIntoConstraints = true
//
//        var tempFrame: CGRect = view.frame
//
//        tempFrame.origin.x *= DISPLAY_SCALE
//        tempFrame.origin.y *= DISPLAY_SCALE
//        tempFrame.size.width *= DISPLAY_SCALE
//        tempFrame.size.height *= DISPLAY_SCALE
//
//        view.frame = tempFrame
//
//        if(view.isKind(of: UILabel.self)) {
//            let tempLabel: UILabel = view as! UILabel
//            tempLabel.font = fontWithDisplayScale(font: tempLabel.font)
//        } else if(view.isKind(of: UIButton.self)) {
//            let tempButton: UIButton = view as! UIButton
//            guard let fontSize = tempButton.titleLabel?.font else { return }
//            tempButton.titleLabel?.font = fontWithDisplayScale(font: fontSize)
//        } else if(view.isKind(of: UITextField.self)) {
//            let tempTextField: UITextField = view as! UITextField
//            guard let fontSize = tempTextField.font else { return }
//            tempTextField.font = fontWithDisplayScale(font: fontSize)
//        }
//    }
//
//    static func resizeWithDisplayScale(view: UIView) {
//        for subview in view.subviews {
//            viewWithDisplayScale(view: subview)
//            resizeWithDisplayScale(view: subview)
//        }
//    }
//
//
//}
