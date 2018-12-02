//
//  TextHeadCollectionViewCell.swift
//  FiMap
//
//  Created by AmamiYou on 2018/10/24.
//  Copyright © 2018 ammYou. All rights reserved.
//

import UIKit

class TextHeadCollectionViewCell: UICollectionViewCell {
    private let textLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = Constants.Color.SOFT_WHITE
        self.textLabel.backgroundColor = UIColor.clear
        self.textLabel.font = UIFont.boldSystemFont(ofSize: 15)
        self.textLabel.textAlignment = .center
        self.contentView.addSubview(self.textLabel)
    }

    public func setCell(text: String) {
        self.textLabel.text = text
    }

    internal override func layoutSubviews() {
        super.layoutSubviews()

        self.textLabel.frame = CGRect(origin: CGPoint.zero, size: self.contentView.bounds.size)
    }


    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    internal override class var requiresConstraintBasedLayout: Bool {

        return false
    }
}
