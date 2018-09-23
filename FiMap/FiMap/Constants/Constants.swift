//
//  Constants.swift
//  FiMap
//
//  Created by AmamiYou on 2018/09/23.
//  Copyright © 2018 ammYou. All rights reserved.
//

import Foundation
import UIKit

struct Constants {
    struct Key {
        static let NCMB_APPLICATION_KEY = ""
        static let NCMB_CLIENT_KEY = ""
    }
    
    struct Color {
        static let NORMAL_WHITE = UIColor(red255: 255, green255: 255, blue255: 255)
        static let FIMAP_THEME = UIColor(red255: 135, green255: 192, blue255: 176)
        static let LIGHT_GARY = UIColor(red255: 248, green255: 248, blue255: 245)
        static let SHADOW = UIColor(red255: 10, green255: 10, blue255: 10)
    }
    
    struct UserDefault {
        static let IS_FIRST_LUNCH = "IS_FIRST_LUNCH"
    }
}
