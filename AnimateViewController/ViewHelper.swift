//
//  ViewHelper.swift
//  JustPaid
//
//  Created by Munzareen Atique on 28/08/2019.
//  Copyright © 2019 Munzareen Atique. All rights reserved.
//

import Foundation
import UIKit


enum VerticalLocation: String {
    case bottom
    case top
}

@IBDesignable extension UIView {
   
    
    
    func addShadowView(color : UIColor){

        print("test")
        let corner_Radius: CGFloat = layer.cornerRadius
        let shadowOffsetWidth: Int = 0
        let shadowOffsetHeight: Int = 1
        let shadowColor: UIColor? = color
        let shadowOpacity: Float = 0.1
        
        layer.cornerRadius = corner_Radius
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: corner_Radius)
        layer.masksToBounds = false
        layer.shadowColor = shadowColor?.cgColor
        
        
        layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight);
        layer.shadowOpacity = shadowOpacity
        layer.shadowPath = shadowPath.cgPath
        
    }
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    
    func chnageBackgrounf(color : UIColor)
    {
        layer.backgroundColor = color.cgColor
    }
    
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
}
