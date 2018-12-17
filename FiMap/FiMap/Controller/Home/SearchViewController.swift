//
//  SearchViewController.swift
//  FiMap
//
//  Created by AmamiYou on 2018/10/21.
//  Copyright © 2018 ammYou. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    // MARK: - Propaties
    public let tableView = UITableView()
    public let titleLabel = UILabel()
    public var dataSource = SearchDataItem()

    // MARK: - Override Function
    override func loadView() {
        super.loadView()
        viewLayoutSetting()
        titleViewLayoutSetting()
        tableViewLayoutSetting()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initSetting()
        self.dataSource.getSearchCategory()
        self.tableView.reloadData()
    }

    private func initSetting() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(searchViewDidEnterNotification(notification:)),
                                               name: Constants.Notification.SEARCH_ENTER,
                                               object: nil)
    }

    // MARK: - Layout Setting
    private func viewLayoutSetting() {
        let topColor = Constants.Color.LIGHT_GREEN
        let middleColor = Constants.Color.IMAGE_COLOR
        let bottomColor = Constants.Color.SHADOW_GREEN
        let gradientColors: [CGColor] = [topColor.cgColor, middleColor.cgColor, bottomColor.cgColor]
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.frame = self.view.bounds
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }

    private func titleViewLayoutSetting() {
        self.view.addSubview(titleLabel)
        self.titleLabel.text = R.string.localized.home_Search_Category()
        self.titleLabel.textColor = Constants.Color.WHITE_GRAY
        self.titleLabel.textAlignment = .center
        self.titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
        self.titleLabel.backgroundColor = Constants.Color.CLEAR
        self.titleLabel.snp.makeConstraints { (make) in
            make.top.width.centerX.equalToSuperview()
            make.height.equalTo(45)
        }
    }

    private func tableViewLayoutSetting() {
        self.view.addSubview(tableView)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.view.backgroundColor = Constants.Color.CLEAR
        self.tableView.backgroundColor = Constants.Color.CLEAR
        self.tableView.sectionIndexBackgroundColor = Constants.Color.CLEAR
        self.tableView.separatorColor = Constants.Color.DARK_GREEN
        self.tableView.separatorStyle = .singleLine
        self.tableView.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleLabel.snp.bottom)
            make.width.bottom.centerX.equalToSuperview()
        }
        self.tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0);
        self.tableView.tableFooterView = UIView(frame: .zero)

        self.tableView.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.className)
        self.tableView.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.className)
    }

    // MARK: - Function
    @objc private func searchViewDidEnterNotification(notification: NSNotification) {
        if let word: String = notification.userInfo?["word"] as? String {
            self.dataSource.title = [word, word]
            self.tableView.reloadData()
        }
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.title.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.className, for: indexPath)
        (cell as? SearchTableViewCell)?.setCell(title: dataSource.title[indexPath.item])
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
}
