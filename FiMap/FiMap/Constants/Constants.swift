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
    
    struct Url {
        static let API_ENDPOINT = "http://35.233.246.171"
        struct Wifi {
            static let GET_POINTS = "/api/wifi/getPoints"
        }
    }

    struct Color {
        //        static let FIMAP_THEME = UIColor(red255: 135, green255: 192, blue255: 176)
        //        static let FIMAP_SECOND_THEME = UIColor(red255: 160, green255: 201, blue255: 159)
        //        static let NAVIGATION_BAR = UIColor(hex: 0x51B17E)
        static let NORMAL_WHITE = UIColor(red255: 255, green255: 255, blue255: 255)
        static let WHITE_GRAY = UIColor(red255: 240, green255: 240, blue255: 240)
        static let IMAGE_COLOR = UIColor(hex: 0x4DD139)
        static let SHADOW = UIColor(red255: 10, green255: 10, blue255: 10)
        static let CLEAR = UIColor.clear
        static let LIGHT_GREEN = UIColor(red255: 147, green255: 199, blue255: 61)
        static let SHADOW_GREEN = UIColor(red255: 80, green255: 177, blue255: 75)
        static let DARK_GREEN = UIColor(red255: 60, green255: 157, blue255: 55)

        // Apple Sky
        static let AppleSky = UIColor(red255: 140, green255: 190, blue255: 220)
        static let AppleSkyShadow = UIColor(red255: 98, green255: 113, blue255: 124)
        
        // Apple Black
        static let AppleBlack = UIColor(red255: 55, green255: 55, blue255: 55)
        static let AppleBlackShadow = UIColor(red255: 75, green255: 75, blue255: 75)
        
        // Gray
        static let AppleGray = UIColor(red255: 201, green255: 201, blue255: 201)
        
        // Aqua blue
        static let AppleAquaBlue = UIColor(red255: 37, green255: 218, blue255: 234)
        static let AppleAquaBlueShadow = UIColor(red255: 18, green255: 132, blue255: 201)
        
    }

    struct Font {
        static let NOTO_SANS = "Noto Sans Chakma Regular"
        static let GUJA_SAN = "Gujarati Sangam MN"
    }

    struct Notification {
        static let SETTING_OPEN = NSNotification.Name("SETTING_OPEN")
        static let SEARCH_ENTER = NSNotification.Name("SEARCH_ENTER")
        static let SEARCH_SELECT = NSNotification.Name("SEARCH_SELECT")
    }
}
