//
//  SideMenuViewController.swift
//  FiMap
//
//  Created by AmamiYou on 2018/09/22.
//  Copyright © 2018 ammYou. All rights reserved.
//

import UIKit

class SideMenuViewController: UITableViewController {

    // MARK: - Property
    private var menuDatasource = [[MenuDataItem]]() // Rows in Sections

    // MARK: - Override

    override func loadView() {
        super.loadView()
        tableViewLayoutSetting()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        initSetting()
        // Do any additional setup after loading the view.
    }

    private func initSetting() {

        /// DataSource =  [0: Logo, 1: Normal]
        let logoRows = [
            MenuDataItem(image: nil, text: nil)
        ]
        let menuRows = [
            MenuDataItem(image: R.image.round_layers_black_48pt(), text: R.string.localized.side_Layer())
//            MenuDataItem(image: R.image.categorize_icon(), text: R.string.localized.side_Category())
        ]
        self.menuDatasource.append(logoRows)
        self.menuDatasource.append(menuRows)

        self.tableView.register(LogoTableViewCell.self, forCellReuseIdentifier: LogoTableViewCell.className)
        self.tableView.register(MenuTableViewCell.self, forCellReuseIdentifier: MenuTableViewCell.className)
    }

    // MARK: - Layout Setting
    private func tableViewLayoutSetting() {
        self.view.backgroundColor = Constants.Color.NORMAL_WHITE
        self.tableView.separatorStyle = .singleLine
        self.tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0);
        self.tableView.tableFooterView = UIView(frame: .zero)
    }
    // MARK: - Function

    // MARK: - Action

    // MARK: - TableView
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.menuDatasource.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menuDatasource[section].count
    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 60.0
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 50.0
        case 1:
            return 60.0
        default:
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: LogoTableViewCell.className, for: indexPath)
//            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: MenuTableViewCell.className, for: indexPath)
            (cell as? MenuTableViewCell)?.setCell(item: menuDatasource[indexPath.section][indexPath.row])
            cell.separatorInset = indexPath.row < self.menuDatasource[indexPath.section].count - 1 ?
            UIEdgeInsets(top: 0, left: tableView.bounds.size.width, bottom: 0, right: 0): tableView.separatorInset
            return cell
        default:
            return UITableViewCell()
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            break
        case 1:
            closeLeft()
            break
        default:
            break
        }
        self.tableView.deselectRow(at: indexPath, animated: true)
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
