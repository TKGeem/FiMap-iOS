//
//  ResultTableViewCell.swift
//  FiMap
//
//  Created by El You on 2018/12/02.
//  Copyright © 2018 ammYou. All rights reserved.
//

import UIKit

class ResultTableViewCell: UITableViewCell {
    private let resultTitleLabel = UILabel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = Constants.Color.CLEAR
        self.resultTitleLabel.textColor = Constants.Color.WHITE_GRAY
        self.resultTitleLabel.font = UIFont.boldSystemFont(ofSize: 15)
        self.resultTitleLabel.textAlignment = .center
        self.resultTitleLabel.adjustsFontSizeToFitWidth = true
        self.resultTitleLabel.adjustsFontForContentSizeCategory = true
        self.contentView.addSubview(self.resultTitleLabel)
        self.resultTitleLabel.snp.makeConstraints { (make) in
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
        self.resultTitleLabel.text = title
    }
}
