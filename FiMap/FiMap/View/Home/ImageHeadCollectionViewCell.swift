//
//  ImageHeadCollectionViewCell.swift
//  FiMap
//
//  Created by AmamiYou on 2018/10/24.
//  Copyright © 2018 ammYou. All rights reserved.
//

import UIKit

class ImageHeadCollectionViewCell: UICollectionViewCell {
    private let logoImageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = Constants.Color.NORMAL_WHITE
        self.logoImageView.contentMode = .scaleAspectFit
        self.logoImageView.image = R.image.fimap_icon()
        self.contentView.addSubview(self.logoImageView)
    }

    internal override func layoutSubviews() {
        super.layoutSubviews()

        self.logoImageView.frame = CGRect(origin: CGPoint.zero, size: self.contentView.bounds.size)
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
