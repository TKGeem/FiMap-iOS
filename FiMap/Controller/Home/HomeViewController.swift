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

class HomeViewController: UIViewController {
    let mapView = GMSMapView()

    override func viewDidLoad() {
        super.viewDidLoad()
        mapViewLayoutSetting()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func mapViewLayoutSetting(){
        do {
            if let styleURL = Bundle.main.url(forResource: "fimap_style", withExtension: "json") {
                mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            } else {
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
