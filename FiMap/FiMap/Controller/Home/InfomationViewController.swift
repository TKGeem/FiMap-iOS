//
//  InfomationViewController.swift
//  FiMap
//
//  Created by El You on 2019/01/10.
//  Copyright © 2019 ammYou. All rights reserved.
//

import UIKit

class InfomationViewController: UIViewController {
    public let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        self.tableView.backgroundColor = UIColor.white
        self.view.backgroundColor = UIColor.gray


        /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    }
}
