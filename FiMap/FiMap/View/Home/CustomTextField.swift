//
//  CustomTextField.swift
//  FiMap
//
//  Created by El You on 2018/12/24.
//  Copyright © 2018 ammYou. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 20.0, dy: 0.0)
    }
    
    //編集中のテキストの余白
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 20.0, dy: 0.0)
    }
    
    //プレースホルダーの余白
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 20, dy: 0.0)
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
