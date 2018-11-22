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
        switch direction {
        case .top:
            self.layer.shadowOffset = CGSize(width: 0.0, height: -1)
        case .bottom:
            self.layer.shadowOffset = CGSize(width: 0.0, height: 1)
        }
        self.layer.shadowRadius = 1.5
        self.layer.shadowColor = Constants.Color.SHADOW.cgColor
        self.layer.shadowOpacity = 0.5
    }
}
