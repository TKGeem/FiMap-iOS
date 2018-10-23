//
//  SettingViewController.swift
//  FiMap
//
//  Created by AmamiYou on 2018/10/09.
//  Copyright © 2018 ammYou. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        initSetting()
        // Do any additional setup after loading the view.
    }

    private func initSetting() {
        self.view.backgroundColor = Constants.Color.LIGHT_GARY
        self.setLeftBackBarButtonItem(action: #selector(tapedBackButton))
        self.setNavigationBarTitleString(title: R.string.localized.setting())
    }

    // MARK: - Layout Setting
    // MARK: - Function
    // MARK: - Action
    @objc private func tapedBackButton() {
        self.dismiss(animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
