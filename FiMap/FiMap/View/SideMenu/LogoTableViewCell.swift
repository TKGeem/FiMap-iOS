//
//  LogoTableViewCell.swift
//  FiMap
//
//  Created by AmamiYou on 2018/09/30.
//  Copyright © 2018 ammYou. All rights reserved.
//

import UIKit

class LogoTableViewCell: UITableViewCell {
    private let logoImageView = UIImageView()
    private let settingButton = UIButton()
    
    override init(style: CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        
        self.logoImageView.image = R.image.logo_icon()
        self.logoImageView.contentMode = .scaleAspectFit
        self.contentView.addSubview(self.logoImageView)
        self.logoImageView.snp.makeConstraints { (make) in
            make.centerY.height.equalToSuperview()
            make.left.equalTo(17)
            make.width.equalTo(70)
        }
        
        self.settingButton.setImage(R.image.setting_icon(), for: .normal)
        self.accessoryView = self.settingButton
        self.settingButton.addTarget(self, action: #selector(tapedSettingButton), for: .touchUpInside)
        self.settingButton.snp.makeConstraints { (make) in
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
    
    override func prepareForReuse() {
        self.logoImageView.image = nil
    }

    // MARK: - Action
    @objc private func tapedSettingButton() {
        
    }
}
