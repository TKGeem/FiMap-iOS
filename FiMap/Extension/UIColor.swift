//
//  UIColor.swift
//  FiMap
//
//  Created by AmamiYou on 2018/08/12.
//  Copyright © 2018年 TKGeem. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    convenience init(hex: Int, alpha: Double = 1.0) {
        let r = CGFloat((hex & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((hex & 0x00FF00) >> 8) / 255.0
        let b = CGFloat(hex & 0x0000FF) / 255.0
        self.init(red: r, green: g, blue: b, alpha: CGFloat(alpha))
    }
    
    convenience init(r255: Float, g255: Float, b255: Float, alpha: Double = 1.0) {
        let r = CGFloat(r255/255.0)
        let g = CGFloat(g255/255.0)
        let b = CGFloat(b255/255.0)
        let a = CGFloat(alpha)
        
        self.init(red: r, green: g, blue: b, alpha: a)
    }
}
