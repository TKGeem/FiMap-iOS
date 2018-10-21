//
//  HomeViewController.swift
//  FiMap
//
//  Created by AmamiYou on 2018/09/22.
//  Copyright © 2018 ammYou. All rights reserved.
//

import UIKit
import MapKit
import SnapKit

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
        // Do any additional setup after loading the view.
        initSetting()
    }

    deinit {
        NotificationCenter.default.removeObserver(self,
                                                  name: Constants.Notification.SETTING_OPEN,
                                                  object: nil)
    }

    private func initSetting() {
        self.view.backgroundColor = UIColor.white

//        let hideTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKyeoboardTap))
//        hideTap.numberOfTapsRequired = 1
//        self.view.isUserInteractionEnabled = true
//        self.view.addGestureRecognizer(hideTap)

        checkMapAccess()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.activityType = CLActivityType.otherNavigation
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.delegate = self
            self.locationManager.startUpdatingLocation()
            self.locationManager.startUpdatingHeading()
        }

        self.mapView.delegate = self
        self.mapView.mapType = .standard
        self.mapView.showsScale = true
        self.mapView.showsCompass = false
        self.mapView.showsTraffic = true
        self.mapView.showsBuildings = true
        self.mapView.showsUserLocation = true
        self.mapView.showsPointsOfInterest = true
//        self.mapView.userTrackingMode = .followWithHeading
        self.mapView.setUserTrackingMode(MKUserTrackingMode.followWithHeading, animated: true)
//        self.locationManager.startUpdatingHeading()

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(openSettingView),
                                               name: Constants.Notification.SETTING_OPEN,
                                               object: nil)
    }

    // MARK: - Layout Setting


    private func mapViewLayoutSetting() {
        self.view.addSubview(self.mapView)
        self.mapView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

    private func menuBarLayoutSetting() {
        // MenuBar
        self.menuBarView.backgroundColor = Constants.Color.LIGHT_GARY
        self.menuBarView.layer.cornerRadius = 10
        self.menuBarView.addShadow(direction: .bottom)
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
        mapCompassButton.addShadow(direction: .bottom)
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
        mapTrackingButton.addShadow(direction: .bottom)
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
//
//        let controller = SettingViewController()
//        let sheetController = SheetViewController(controller: controller)
//        sheetController.blurBottomSafeArea = false
//        sheetController.overlayColor = UIColor.clear
//        sheetController.adjustForBottomSafeArea = true
//        sheetController.showaPullBar = false
//        self.present(sheetController, animated: false, completion: nil)
//        sheetController.containerView.addShadow(direction: .bottom)
    }

    @objc private func openSettingView() {
        self.pushNewNavigationController(rootViewController: SettingViewController(),
                                         animation: .cover(direction: .up))
//        self.navigationController?.pushViewController(SettingViewController(), animated: true)
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

extension HomeViewController: CLLocationManagerDelegate {
}
extension HomeViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didChange mode: MKUserTrackingMode, animated: Bool) {
        print(mode.rawValue)
        print(animated)
    }
}
