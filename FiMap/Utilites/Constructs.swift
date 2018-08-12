//
//  Constructs.swift
//  FiMap
//
//  Created by AmamiYou on 2018/08/12.
//  Copyright © 2018年 TKGeem. All rights reserved.
//

import Foundation
import UIKit

struct Constains {
    struct SHARE_VAR {
        static let sd = UIApplication.shared.delegate as! AppDelegate
    }
    
    struct API_KEY {
        static let GMS_APU_KEY = ""
    }
    
    struct Color {
        static let THEME = UIColor.init(r255: 0, g255: 160, b255: 176, alpha: 1.0)//x00A0B0
        static let LIGHT_GRAY = UIColor.init(r255: 68, g255: 68, b255: 68, alpha: 1.0)//x444444
        static let RIME_GREEN = UIColor.init(r255: 108, g255: 219, b255: 190, alpha: 1.0)//x6CDBBE
        static let TEA_GREEN = UIColor.init(r255: 159, g255: 184, b255: 42, alpha: 1.0)//x9FB82A
        static let WHITE = UIColor.init(r255: 243, g255: 245, b255: 244, alpha: 1.0)//xF3F5F4
    }
}
