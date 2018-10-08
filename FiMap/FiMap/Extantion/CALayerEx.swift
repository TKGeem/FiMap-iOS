//
//  CALayerEx.swift
//  FiMap
//
//  Created by AmamiYou on 2018/09/23.
//  Copyright © 2018 ammYou. All rights reserved.
//

import Foundation
import UIKit

public extension CALayer {
    enum Direction {
        case top
        case bottom
    }

    public func addShadow(direction: Direction) {
        switch direction {
        case .top:
            self.shadowOffset = CGSize(width: 0.0, height: -1)
        case .bottom:
            self.shadowOffset = CGSize(width: 0.0, height: 1)
        }
        self.shadowRadius = 1.5
        self.shadowColor = Constants.Color.SHADOW.cgColor
        self.shadowOpacity = 0.5
    }
}
