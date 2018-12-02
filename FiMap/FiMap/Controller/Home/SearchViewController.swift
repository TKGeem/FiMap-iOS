//
//  SearchViewController.swift
//  FiMap
//
//  Created by AmamiYou on 2018/10/21.
//  Copyright © 2018 ammYou. All rights reserved.
//

import UIKit


class SearchViewController: UIViewController {
    public var delegate: HomeViewControllerDelegate!
    public let tableView = UITableView()


    override func loadView() {
        super.loadView()
        self.view.addSubview(tableView)
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
