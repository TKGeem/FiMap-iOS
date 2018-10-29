//
//  CategoryDataItem.swift
//  FiMap
//
//  Created by AmamiYou on 2018/10/29.
//  Copyright © 2018 ammYou. All rights reserved.
//

import Foundation
import UIKit

class CategoryDataItem: NSObject {
    let name: String?
    let color: UIColor?

    init(name: String?, color: UIColor?) {
        self.name = name
        self.color = color
    }
}
