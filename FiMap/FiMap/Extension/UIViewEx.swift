//
//  UIViewEx.swift
//  FiMap
//
//  Created by AmamiYou on 2018/09/23.
//  Copyright © 2018 ammYou. All rights reserved.
//

import Foundation
import UIKit

public extension UIView {
    public var viewController: UIViewController? {
        var parent: UIResponder? = self
        while parent != nil {
            parent = parent?.next
            if let viewController = parent as? UIViewController {
                return viewController
            }
        }
        return nil
    }

    enum Direction {
        case top
        case bottom
    }
    public func addShadow(direction: Direction) {
        let shadowLayer = CALayer()
        shadowLayer.frame = self.frame
        switch direction {
        case .top:
            shadowLayer.shadowOffset = CGSize(width: 0.0, height: -1)
        case .bottom:
            shadowLayer.shadowOffset = CGSize(width: 0.0, height: 1)
        }
        shadowLayer.shadowRadius = 1.5
        shadowLayer.shadowColor = UIColor.gray.cgColor
        shadowLayer.shadowOpacity = 0.5
        shadowLayer.masksToBounds = true

        self.layer.addSublayer(shadowLayer)
    }
}
