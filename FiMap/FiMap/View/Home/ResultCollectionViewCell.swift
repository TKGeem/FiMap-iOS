//
//  ResultCollectionViewCell.swift
//  FiMap
//
//  Created by AmamiYou on 2018/10/24.
//  Copyright © 2018 ammYou. All rights reserved.
//

import UIKit

import UIKit

internal final class ResultCollectionViewCell: UICollectionViewCell {

    // MARK: - Internal Properties

    internal var colorView: UIView!

    internal var label: UILabel!

    // MARK: - Object Lifecycle

    internal override init(frame: CGRect) {

        super.init(frame: frame)

        self.colorView = UIView()
        self.label = UILabel()

//        self.colorView.layer.cornerRadius = 10.0
//        self.colorView.layer.masksToBounds = true
        self.label.textAlignment = .center
        self.label.textColor = Constants.Color.SHADOW

        self.contentView.addSubview(self.colorView)
        self.contentView.addSubview(self.label)
    }

    internal required init?(coder aDecoder: NSCoder) {

        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout

    internal override func layoutSubviews() {

        super.layoutSubviews()

        self.colorView.frame = CGRect(origin: CGPoint.zero, size: self.contentView.bounds.size)
        self.label.frame = CGRect(origin: CGPoint.zero, size: self.contentView.bounds.size)
    }

    internal override class var requiresConstraintBasedLayout: Bool {

        return false
    }
}
