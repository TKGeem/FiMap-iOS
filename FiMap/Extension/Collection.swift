//
//  Collection.swift
//  FiMap
//
//  Created by AmamiYou on 2018/08/12.
//  Copyright © 2018年 TKGeem. All rights reserved.
//

import Foundation

extension Collection {
    subscript(safe index: Index) -> Element? {
        return index >= startIndex && index < endIndex ? self[index] : nil
    }
}
