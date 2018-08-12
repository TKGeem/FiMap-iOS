//
//  HomeViewController.swift
//  FiMap
//
//  Created by AmamiYou on 2018/08/12.
//  Copyright © 2018年 TKGeem. All rights reserved.
//

import UIKit
import SnapKit
import SideMenu
import GoogleMaps
import GooglePlaces
import GooglePlacePicker

class HomeViewController: UIViewController {
    let mapView = GMSMapView()
    let sideMenuBtton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        mapViewSetting()
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func sideMenuViewSetting(){
        let sideMenuVC = SideMenuViewController()
        let leftSideMenuNavigationVC = UISideMenuNavigationController(rootViewController: sideMenuVC)
        SideMenuManager.default.menuLeftNavigationController = leftSideMenuNavigationVC
    }
    
    private func mapViewSetting(){
        do {
            if let styleURL = Bundle.main.url(forResource: "fimap_style", withExtension: "json") {
                self.mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            } else {
                self.mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: R.file.fimap_styleJson()!)
                NSLog("Unable to find style")
            }
        } catch {
            NSLog("One or more of the map styles failed to load. \(error)")
        }
        mapView.isMyLocationEnabled = true
        mapView.isIndoorEnabled = true
        mapView.isTrafficEnabled = true
        mapView.isBuildingsEnabled = true
       
        self.view.addSubview(mapView)
        mapView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
