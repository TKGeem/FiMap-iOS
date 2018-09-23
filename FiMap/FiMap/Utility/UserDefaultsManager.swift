//
//  UserDefaultsManager.swift
//  FiMap
//
//  Created by AmamiYou on 2018/09/23.
//  Copyright © 2018 ammYou. All rights reserved.
//

import Foundation

class UserDefaultsManager {
    static let client = UserDefaults.standard
    
    static func setValue(key: String, value: Any) {
        client.set(value, forKey: key)
    }
    
    static func getValue(key: String) -> Any? {
        return client.object(forKey: key)
    }
    
}
