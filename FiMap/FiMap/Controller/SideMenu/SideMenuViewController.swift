//
//  SideMenuViewController.swift
//  FiMap
//
//  Created by AmamiYou on 2018/09/22.
//  Copyright © 2018 ammYou. All rights reserved.
//

import UIKit

class SideMenuViewController: UITableViewController{
    
    // MARK: - Property
    private let menuTableView = UITableView()
    private var menuDatasource = [MenuDataItem]()
    
    // MARK: - Override
    override func loadView() {
        super.loadView()
        self.view.backgroundColor = Constants.Color.LIGHT_GARY
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - Layout Setting
    
    // MARK: - Function
    
    // MARK: - Action
    
    // TableView
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
