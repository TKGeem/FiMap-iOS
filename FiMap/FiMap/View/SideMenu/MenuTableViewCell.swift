//
//  MenuTableViewCell.swift
//  FiMap
//
//  Created by AmamiYou on 2018/09/30.
//  Copyright © 2018 ammYou. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {
    private let logoImageView = UIImageView()
    private let titleLbl = UILabel()
    
    override init(style: CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        
        self.logoImageView.contentMode = .scaleAspectFit
        self.contentView.addSubview(self.logoImageView)
        self.logoImageView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(17)
            make.width.equalTo(26)
            make.height.equalTo(23)
        }
        
        self.titleLbl.font = UIFont.systemFont(ofSize: 13)
        self.titleLbl.textAlignment = .left
        self.contentView.addSubview(self.titleLbl)
        self.titleLbl.snp.makeConstraints { (make) in
            make.left.equalTo(self.logoImageView.snp.right).offset(20)
            make.centerY.right.equalToSuperview()
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
        self.logoImageView.image = nil
        self.titleLbl.text = nil
    }
    
    func setCell(item: MenuDataItem) {
        self.logoImageView.image = item.image
        self.titleLbl.text = item.text
    }
}
