//
//  SearchTableViewCell.swift
//  FiMap
//
//  Created by El You on 2018/12/02.
//  Copyright © 2018 ammYou. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    private let searchTitleLabel = UILabel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = Constants.Color.CLEAR
        self.searchTitleLabel.textColor = Constants.Color.WHITE_GRAY
        self.searchTitleLabel.font = UIFont.boldSystemFont(ofSize: 30)
        self.searchTitleLabel.textAlignment = .center
        self.searchTitleLabel.adjustsFontSizeToFitWidth = true
        self.searchTitleLabel.adjustsFontForContentSizeCategory = true
        self.contentView.addSubview(self.searchTitleLabel)
        self.searchTitleLabel.snp.makeConstraints { (make) in
            make.height.centerX.centerY.equalToSuperview()
            make.width.equalToSuperview().offset(-15)
        }
        
        let cellSelectedBgView = UIView()
        cellSelectedBgView.backgroundColor = Constants.Color.SHADOW_GREEN
        self.selectedBackgroundView = cellSelectedBgView
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    public func setCell(title: String) {
        self.searchTitleLabel.text = title
    }
}
