//
//  InformationTableViewCell.swift
//  FiMap
//
//  Created by El You on 2019/02/06.
//  Copyright © 2019 ammYou. All rights reserved.
//

import UIKit

class InformationTableViewCell: UITableViewCell {
    private let nameLabel = UILabel()
    private let addressLabel = UILabel()
    private let postCodeLabel = UILabel()
    private let urlTxf = UITextField()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        self.backgroundColor = Constants.Color.CLEAR
//        self.searchTitleLabel.textColor = Constants.Color.WHITE_GRAY
//        self.searchTitleLabel.font = UIFont.boldSystemFont(ofSize: 30)
//        self.searchTitleLabel.textAlignment = .center
//        self.searchTitleLabel.adjustsFontSizeToFitWidth = true
//        self.searchTitleLabel.adjustsFontForContentSizeCategory = true
//        self.contentView.addSubview(self.searchTitleLabel)
//        self.searchTitleLabel.snp.makeConstraints { (make) in
//            make.height.centerX.centerY.equalToSuperview()
//            make.width.equalToSuperview().offset(-15)
//        }
        
//        let cellSelectedBgView = UIView()
//        cellSelectedBgView.backgroundColor = Constants.Color.SHADOW_GREEN
//        self.selectedBackgroundView = cellSelectedBgView
        self.selectionStyle = .none
        self.backgroundColor = Constants.Color.CLEAR
        
        self.nameLabel.backgroundColor = Constants.Color.CLEAR
        self.nameLabel.font = UIFont.boldSystemFont(ofSize: 20)
        self.nameLabel.textAlignment = .left
        self.nameLabel.numberOfLines = 0
        self.nameLabel.adjustsFontSizeToFitWidth = true
        self.nameLabel.adjustsFontForContentSizeCategory = true
        self.contentView.addSubview(self.nameLabel)
        self.nameLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(20)
            make.top.equalTo(10)
            
        }
        
        self.addressLabel.backgroundColor = Constants.Color.CLEAR
        self.addressLabel.font = UIFont.systemFont(ofSize: 15)
        self.addressLabel.textAlignment = .left
        self.addressLabel.numberOfLines = 0
        self.addressLabel.adjustsFontSizeToFitWidth = true
        self.addressLabel.adjustsFontForContentSizeCategory = true
        self.contentView.addSubview(self.addressLabel)
        self.addressLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(10)
            make.top.equalTo(self.nameLabel.snp.bottom).offset(10)
        }
        
        self.postCodeLabel.backgroundColor = Constants.Color.CLEAR
        self.postCodeLabel.font = UIFont.systemFont(ofSize: 15)
        self.postCodeLabel.textAlignment = .left
        self.postCodeLabel.numberOfLines = 0
        self.postCodeLabel.adjustsFontSizeToFitWidth = true
        self.postCodeLabel.adjustsFontForContentSizeCategory = true
        self.contentView.addSubview(self.postCodeLabel)
        self.postCodeLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(10)
            make.top.equalTo(self.addressLabel.snp.bottom).offset(5)
//            make.bottom.equalTo(-10)
        }
        
        self.urlTxf.backgroundColor = Constants.Color.CLEAR
        self.urlTxf.font = UIFont.systemFont(ofSize: 13)
        self.urlTxf.textAlignment = .left
        self.urlTxf.adjustsFontSizeToFitWidth = true
        self.urlTxf.adjustsFontForContentSizeCategory = true
        self.urlTxf.allowsEditingTextAttributes = false
        self.contentView.addSubview(self.urlTxf)
        self.urlTxf.snp.makeConstraints { (make) in
            make.left.right.equalTo(10)
            make.top.equalTo(self.postCodeLabel.snp.bottom).offset(10)
            make.bottom.equalTo(-10)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    public func setCell(data: WifiData) {
        self.nameLabel.text = data.name ?? ""
        self.addressLabel.text = data.address ?? ""
        self.postCodeLabel.text = "〒: \(data.postCode ?? "")"
        self.urlTxf.text = "\(data.hpURL ?? "")"
        self.layoutIfNeeded()
//        self.searchTitleLabel.text = data.
    }
}
