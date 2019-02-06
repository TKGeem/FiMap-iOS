//
//  SkyFloatingEx.swift
//  SalesIncome
//
//  Created by AmamiYou on 2018/11/01.
//  Copyright © 2018 ammYou. All rights reserved.
//

import Foundation
import SkyFloatingLabelTextField

extension SkyFloatingLabelTextField {
    public func setMyAppStyle() {
        let numberToolbar: UIToolbar = UIToolbar()
        numberToolbar.barStyle = .default
        numberToolbar.items = [
            UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: "完了", style: .done, target: self, action: #selector(closeKeyBoard))
        ]
        numberToolbar.sizeToFit()
        self.titleColor = Constants.Color.AppleBlack
        self.selectedTitleColor = Constants.Color.AppleBlack
        self.placeholderColor = Constants.Color.AppleGray
        self.textColor = Constants.Color.AppleBlack
        self.font = UIFont.boldSystemFont(ofSize: 30)
        self.placeholderFont = UIFont.boldSystemFont(ofSize: 20)
        self.titleFont = UIFont.boldSystemFont(ofSize: 20)
        self.inputAccessoryView = numberToolbar
        self.keyboardType = .numberPad
        self.textAlignment = .center
    }

    @objc func closeKeyBoard() {
        self.endEditing(true)
    }
}
