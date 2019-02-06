//
//  MenuDataItem.swift
//  FiMap
//
//  Created by AmamiYou on 2018/09/30.
//  Copyright © 2018 ammYou. All rights reserved.
//

import UIKit

class MenuDataItem: NSObject {
    let image: UIImage?
    let text: String?

    init(image: UIImage?, text: String?) {
        self.image = image
        self.text = text
    }
}
