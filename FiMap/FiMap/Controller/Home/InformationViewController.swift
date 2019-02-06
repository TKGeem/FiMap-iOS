//
//  InformationViewController.swift
//  FiMap
//
//  Created by El You on 2019/01/10.
//  Copyright © 2019 ammYou. All rights reserved.
//

import UIKit
import Alamofire

class InformationViewController: UIViewController {
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
        NotificationCenter.default.removeObserver(self, name: Constants.Notification.SELECT_ENTER, object: nil)
    }
    
    private func initSetting() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(homeViewDidEnterNotification(notification:)),
                                               name: Constants.Notification.SELECT_ENTER,
                                               object: nil)
    }
    
    // MARK: - Layout Setting
    private func viewLayoutSetting() {
        let topColor = Constants.Color.NORMAL_WHITE
        let middleColor = Constants.Color.WHITE_GRAY
        let bottomColor = Constants.Color.NORMAL_WHITE
        let gradientColors: [CGColor] = [topColor.cgColor, middleColor.cgColor, bottomColor.cgColor]
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.frame = self.view.bounds
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private func titleViewLayoutSetting() {
        self.view.addSubview(titleLabel)
        self.titleLabel.text = R.string.localized.home_Information_Title()
        self.titleLabel.textColor = Constants.Color.AppleBlack
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
        self.tableView.estimatedRowHeight = 200
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0);
        self.tableView.tableFooterView = UIView(frame: .zero)
        
        self.tableView.register(InformationTableViewCell.self, forCellReuseIdentifier: InformationTableViewCell.className)
    }
    
    // MARK: - Function
    @objc private func homeViewDidEnterNotification(notification: NSNotification) {
        self.tableView.reloadData()
    }
}

extension InformationViewController: UITableViewDelegate, UITableViewDataSource {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        NotificationCenter.default.post(name: Constants.Notification.DISSMISS_KEYBOARD, object: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.searchData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: InformationTableViewCell.className, for: indexPath)
        (cell as? InformationTableViewCell)?.setCell(data: dataSource.searchData[indexPath.item])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
}
