//
//  MenuTableViewCell.swift
//  FiMap
//
//  Created by AmamiYou on 2018/09/30.
//  Copyright © 2018 ammYou. All rights reserved.
//

import UIKit
import SnapKit

class MenuTableViewCell: UITableViewCell {
    private let iconImageView = UIImageView()
    private let titleLbl = UILabel()

    override init(style: CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .gray
        self.backgroundColor = Constants.Color.SOFT_WHITE
        self.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)

        self.iconImageView.tintColor = Constants.Color.IMAGE_COLOR
        self.contentView.addSubview(self.iconImageView)
        self.iconImageView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(15)
            make.width.height.equalTo(30)
        }

        self.titleLbl.textAlignment = .left
        self.titleLbl.font = UIFont.boldSystemFont(ofSize: 13)
        self.contentView.addSubview(self.titleLbl)
        self.titleLbl.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(self.iconImageView.snp.right).offset(30)
            make.right.equalToSuperview().offset(-15)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func prepareForReuse() {
        self.iconImageView.image = nil
        self.titleLbl.text = nil
    }

    func setCell(item: MenuDataItem) {
        self.iconImageView.image = item.image
        self.titleLbl.text = item.text
    }
}
