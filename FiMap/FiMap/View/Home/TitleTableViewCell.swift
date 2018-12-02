//
//  TitleTableViewCell.swift
//  FiMap
//
//  Created by El You on 2018/12/02.
//  Copyright © 2018 ammYou. All rights reserved.
//

import UIKit
import SnapKit

class TitleTableViewCell: UITableViewCell {
    private var titleLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.backgroundColor = Constants.Color.CLEAR

        self.contentView.addSubview(self.titleLabel)
        self.titleLabel.textColor = Constants.Color.WHITE_GRAY
        self.titleLabel.textAlignment = .center
        self.titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
        self.titleLabel.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
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

    public func setCell(title: String) {
        self.titleLabel.text = title
    }

}
