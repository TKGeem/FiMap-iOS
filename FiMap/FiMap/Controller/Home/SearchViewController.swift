//
//  SearchViewController.swift
//  FiMap
//
//  Created by AmamiYou on 2018/10/21.
//  Copyright © 2018 ammYou. All rights reserved.
//

import UIKit
import Alamofire

class SearchViewController: UIViewController {
    enum presentMode {
        case category
        case result
    }

    // MARK: - Propaties
    public let tableView = UITableView()
    public let titleLabel = UILabel()
    public var titleWord = String()
    public var dataSource = SearchDataSource()
    private var presentVC = presentMode.category


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
        self.dataSource.getSearchCategory() {
            self.tableView.reloadData()
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: Constants.Notification.SEARCH_ENTER, object: nil)
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
            make.width.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(100)
        }
        self.tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0);
        self.tableView.tableFooterView = UIView(frame: .zero)

        self.tableView.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.className)
        self.tableView.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.className)
        self.tableView.register(ResultTableViewCell.self, forCellReuseIdentifier: ResultTableViewCell.className)
    }

    // MARK: - Function
    @objc private func searchViewDidEnterNotification(notification: NSNotification) {
        if let word: String = notification.userInfo?[Constants.NotificationInfo.WORD] as? String {
            self.titleWord = word
            if word == "" {
                self.dataSource.getSearchCategory() {
                    self.presentVC = .category
                    if self.titleWord == "" {
                        self.tableView.reloadData()
                    }
                }
            } else {
                self.dataSource.searchWifiData(searchWord: word) {
                    self.presentVC = .result
                    if self.titleWord != "" {
                        self.tableView.reloadData()
                    }
                }
            }
        } else {
            self.dataSource.getSearchCategory() {
                self.presentVC = .category
                self.tableView.reloadData()
            }
        }
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        NotificationCenter.default.post(name: Constants.Notification.DISSMISS_KEYBOARD, object: nil)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch presentVC {
        case .category:
            return self.dataSource.searchTitle.count
        case .result:
            return self.dataSource.searchData.count + 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch presentVC {
        case .category:
            let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.className, for: indexPath)
            (cell as? SearchTableViewCell)?.setCell(title: dataSource.searchTitle[indexPath.item])
            return cell
        case .result:
            if (indexPath.item == 0) {
                let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.className, for: indexPath)
                (cell as? TitleTableViewCell)?.setCell(title: self.titleWord)
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: ResultTableViewCell.className, for: indexPath)
                (cell as? ResultTableViewCell)?.setCell(data: dataSource.searchData[indexPath.item - 1])
                return cell
            }
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch presentVC {
        case .category:
            return 80
        case .result:
            return 50
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch presentVC {
        case .category:
            break
        case .result:
            if (indexPath.item == 0) {
                print(self.titleWord)
            } else {
                NotificationCenter.default.post(name: Constants.Notification.SEARCH_SELECT, object: nil, userInfo: [Constants.NotificationInfo.DATA: self.dataSource.searchData[indexPath.item - 1]])
            }
        }
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
}
