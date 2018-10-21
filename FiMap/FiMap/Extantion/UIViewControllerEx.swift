//
//  UIViewControllerEx.swift
//  FiMap
//
//  Created by AmamiYou on 2018/10/09.
//  Copyright © 2018 ammYou. All rights reserved.
//

import Foundation
import UIKit
import Hero

extension UIViewController {
    /// Push ViewController on new NavigationController
    func pushNewNavigationController(rootViewController: UIViewController, animation: HeroDefaultAnimationType) {
        rootViewController.hero.isEnabled = true
        rootViewController.hero.modalAnimationType = animation

        let navigationVC = UINavigationController(rootViewController: rootViewController)
        navigationVC.navigationBar.barTintColor = Constants.Color.NAVIGATION_BAR
        navigationVC.navigationBar.addShadow(direction: .bottom)

        self.present(navigationVC, animated: true, completion: nil)
    }

    /// Sets the navigation bar menu on the left bar button.
    /// Also add the left gesture.
    func setLeftBackBarButtonItem(action: Selector = #selector(tappedBackButton)) {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.createBarButton(image: R.image.backW_icon(), position: .left, target: self, action: action)
    }
    /// Sets the navigation bar menu on the left bar button.
    /// Also add the left gesture.
    func setRightCloseBarButtonItem(action: Selector = #selector(tappedCloseButton)) {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.createBarButton(image: R.image.closeW_icon(), position: .right, target: self, action: action)
    }

    @objc private func tappedBackButton() {
        self.navigationController?.popViewController(animated: true)
    }

    @objc private func tappedCloseButton() {
        self.navigationController?.popToRootViewController(animated: true)
    }

    func setNavigationBarTitleString(title: String) {
        let titleLbl = UILabel()
        titleLbl.font = UIFont.boldSystemFont(ofSize: 20)
        titleLbl.text = title
        titleLbl.sizeToFit()
        titleLbl.textColor = Constants.Color.LIGHT_GARY
        titleLbl.textAlignment = .center
        titleLbl.contentMode = .scaleAspectFit
        self.navigationItem.titleView = titleLbl
    }

    func setNavigationBarTitleLogo() {
        let logoView = UIImageView(image: UIImage(named: "logo_pay_header"))
        logoView.contentMode = .scaleAspectFit
        self.navigationItem.titleView = logoView
    }
}
