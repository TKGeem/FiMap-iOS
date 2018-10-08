//
//  HomeViewController.swift
//  FiMap
//
//  Created by AmamiYou on 2018/09/22.
//  Copyright © 2018 ammYou. All rights reserved.
//

import UIKit
import MapKit

protocol HomeViewControllerDelegate {
    func openSetting()
}

class HomeViewController: UIViewController {
    // MARK: - Property
    private let mapView = MKMapView()
    private let menuBarView = UIView()
    private let searchButton = UIButton()
    private let sideMenuButton = UIButton()
    private let menuBarText = UITextField()

    let locationManager = CLLocationManager()

    // MARK: - Override
    override func loadView() {
        super.loadView()
        mapViewLayoutSetting()
        menuBarLayoutSetting()
        maptoolLayoutSetting()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        checkMapAccess()

        let hideTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKyeoboardTap))
        hideTap.numberOfTapsRequired = 1
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(hideTap)
        // Do any additional setup after loading the view.
    }

    // MARK: - Layout Setting
    private func mapViewLayoutSetting() {
        self.view.addSubview(self.mapView)
        self.mapView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        self.mapView.mapType = .standard
    }

    private func menuBarLayoutSetting() {
        // MenuBar
        self.menuBarView.backgroundColor = Constants.Color.LIGHT_GARY
        self.menuBarView.layer.cornerRadius = 10
        self.menuBarView.layer.addShadow(direction: .bottom)
        self.view.addSubview(self.menuBarView)
        self.menuBarView.snp.makeConstraints { (make) in
            make.left.equalTo(7)
            make.right.equalTo(-7)
            make.height.equalTo(50)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(10)
        }


        // SideMenu
        self.sideMenuButton.setImage(R.image.menu_icon(), for: .normal)
        self.sideMenuButton.addTarget(self, action: #selector(tappedSideMenuButton), for: .touchUpInside)
        self.menuBarView.addSubview(self.sideMenuButton)
        self.sideMenuButton.snp.makeConstraints { (make) in
            make.height.width.equalTo(30)
            make.top.left.equalTo(10)
        }

        // Search
        self.searchButton.setImage(R.image.search_icon(), for: .normal)
        self.menuBarView.addSubview(self.searchButton)
        self.searchButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(34)
            make.top.equalTo(8)
            make.right.equalTo(-8)
        }


        // Text
        self.menuBarText.text = nil
        self.menuBarText.placeholder = R.string.localized.home_Search()
        self.menuBarView.addSubview(self.menuBarText)
        self.menuBarText.snp.makeConstraints { (make) in
            make.left.equalTo(self.sideMenuButton.snp.right).offset(10)
            make.right.equalTo(self.searchButton.snp.left).offset(-10)
            make.height.top.equalTo(self.menuBarView)
        }
    }

    private func maptoolLayoutSetting() {
        // Compass
        let mapCompassButton = MKCompassButton(mapView: self.mapView)
        mapCompassButton.compassVisibility = .visible
        mapCompassButton.layer.addShadow(direction: .bottom)
        self.mapView.showsCompass = false
        self.mapView.addSubview(mapCompassButton)
        mapCompassButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(15)
            make.right.equalTo(self.menuBarView.snp.right).offset(-17)
            make.top.equalTo(self.menuBarView.snp.bottom).offset(30)
        }


        // Tracking
        let mapTrackingButton = MKUserTrackingButton(mapView: self.mapView)
        mapTrackingButton.tintColor = Constants.Color.LIGHT_GARY
        mapTrackingButton.backgroundColor = Constants.Color.FIMAP_THEME
        mapTrackingButton.layer.cornerRadius = 5
        mapTrackingButton.layer.addShadow(direction: .bottom)
        self.mapView.addSubview(mapTrackingButton)
        mapTrackingButton.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-50)
            make.right.equalToSuperview().offset(-20)
            make.width.height.equalTo(40)
        }

        // Scale
        let mapScaleView = MKScaleView(mapView: self.mapView)
        mapScaleView.legendAlignment = .trailing
        self.mapView.addSubview(mapScaleView)
        mapScaleView.snp.makeConstraints { (make) in
            make.bottom.equalTo(mapTrackingButton)
            make.right.equalTo(mapTrackingButton.snp.left).offset(-10)
        }
    }

    // MARK: - Function
    private func checkMapAccess() {
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            self.locationManager.requestAlwaysAuthorization()
        case .restricted:
            self.locationManager.requestAlwaysAuthorization()
        case .denied:
            self.locationManager.requestAlwaysAuthorization()
        case .authorizedWhenInUse:
            self.locationManager.requestAlwaysAuthorization()
        case .authorizedAlways:
            self.locationManager.requestAlwaysAuthorization()
        }
    }
    // MARK: - Action
    @objc private func hideKyeoboardTap(recognizer: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }

    @objc private func tappedSideMenuButton() {
        openLeft()
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
