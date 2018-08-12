//
//  MapView.swift
//  FiMap
//
//  Created by AmamiYou on 2018/07/15.
//  Copyright © 2018年 TKGeem. All rights reserved.
//

import UIKit
import Mapbox

class MapView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(MBMapView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
