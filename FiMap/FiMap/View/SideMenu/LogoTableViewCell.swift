//
//  LogoTableViewCell.swift
//  FiMap
//
//  Created by AmamiYou on 2018/09/30.
//  Copyright © 2018 ammYou. All rights reserved.
//

import UIKit
import SnapKit

class LogoTableViewCell: UITableViewCell {
    private let logoImageView = UIImageView()
    private let settingButton = UIButton()

    override init(style: CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.backgroundColor = Constants.Color.SOFT_WHITE

        self.settingButton.contentMode = .scaleAspectFit
        self.settingButton.setImage(R.image.round_settings_black_48pt(), for: .normal)
        self.settingButton.tintColor = Constants.Color.IMAGE_COLOR
        self.settingButton.addTarget(self, action: #selector(tapedSettingButton), for: .touchUpInside)
        self.contentView.addSubview(self.settingButton)
        self.settingButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-15)
            make.width.height.equalTo(25)
        }

//        self.logoImageView.backgroundColor = UIColor.red
        self.logoImageView.contentMode = .scaleAspectFit
        self.logoImageView.image = R.image.fimap_icon()
        self.contentView.addSubview(self.logoImageView)
        self.logoImageView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(15)
            make.height.equalTo(25)
            make.right.equalTo(self.settingButton.snp.left).offset(-25)
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
        self.viewController?.closeLeft()
        NotificationCenter.default.post(name: Constants.Notification.SETTING_OPEN,
                                        object: nil)
    }
}
