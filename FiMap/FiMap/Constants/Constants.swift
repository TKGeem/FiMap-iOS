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
        static let FIMAP_SECOND_THEME = UIColor(red255: 160, green255: 201, blue255: 159)
        static let NAVIGATION_BAR = UIColor(hex: 0x51B17E)
        static let LIGHT_GARY = UIColor(red255: 250, green255: 250, blue255: 247)
        static let SHADOW = UIColor(red255: 10, green255: 10, blue255: 10)
    }

    struct Font {
        static let NOTO_SANS = "Noto Sans Chakma Regular"
        static let GUJA_SAN = "Gujarati Sangam MN"
    }

    struct Notification {
        static let SETTING_OPEN = NSNotification.Name("SETTING_OPEN")
    }
}
