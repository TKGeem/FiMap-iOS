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
import FloatingPanel

class HomeViewController: UIViewController {
    // MARK: - Property
    private let mapView = MKMapView()
    private let menuBarView = UIView()
    private let searchButton = UIButton()
    private var mapCompassButton: MKCompassButton!

    private let floatingBar = FloatingPanelController()

    public let locationManager = CLLocationManager()

    // MARK: - Override
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }

    override func loadView() {
        super.loadView()
        mapViewLayoutSetting()
        menuBarLayoutSetting()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initSetting()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateMapSetting()
    }

    deinit {
        NotificationCenter.default.removeObserver(self,
                                                  name: Constants.Notification.SETTING_OPEN,
                                                  object: nil)
    }

    private func initSetting() {
        self.view.backgroundColor = UIColor.white
        self.floatingBar.move(to: .tip, animated: true)

        let hideTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tappedScreen(recognizer:)))
        hideTap.numberOfTapsRequired = 1
        hideTap.cancelsTouchesInView = false
        hideTap.delegate = self
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(hideTap)

        checkMapAccess()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.activityType = CLActivityType.otherNavigation
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.delegate = self
            self.locationManager.startUpdatingLocation()
            self.locationManager.startUpdatingHeading()
        }
        self.mapView.delegate = self
        self.floatingBar.delegate = self

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
        self.menuBarView.addShadow(direction: .bottom)
        self.view.addSubview(self.menuBarView)
        self.menuBarView.snp.makeConstraints { (make) in
            make.bottom.centerX.width.equalToSuperview()
            make.height.equalTo(104)
        }

        // SearchButton
        self.searchButton.backgroundColor = Constants.Color.LIGHT_GARY
        self.searchButton.layer.cornerRadius = 30
        self.searchButton.setImage(R.image.search_icon(), for: .normal)
        self.searchButton.imageEdgeInsets = .init(top: 9, left: 9, bottom: 9, right: 9)
        self.searchButton.addTarget(self, action: #selector(tappedSearchButton), for: .touchUpInside)
        self.searchButton.addShadow(direction: .bottom)
        self.menuBarView.addSubview(self.searchButton)
        self.searchButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.height.width.equalTo(60)
            make.top.equalToSuperview().offset(-20)
        }

        // SideMenu
        let sideMenuButton = UIButton()
        sideMenuButton.setImage(R.image.menu_icon(), for: .normal)
        sideMenuButton.addTarget(self, action: #selector(tappedSideMenuButton), for: .touchUpInside)
        menuBarView.addSubview(sideMenuButton)
        sideMenuButton.snp.makeConstraints { (make) in
            make.height.width.equalTo(35)
            make.top.equalTo(10)
            make.left.equalTo(20)
        }

        // Tracking
        let mapTrackingButton = MKUserTrackingButton(mapView: self.mapView)
        mapTrackingButton.tintColor = Constants.Color.LIGHT_GARY
        mapTrackingButton.backgroundColor = Constants.Color.FIMAP_THEME
        mapTrackingButton.layer.cornerRadius = 5
        mapTrackingButton.addShadow(direction: .bottom)
        self.menuBarView.addSubview(mapTrackingButton)
        mapTrackingButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(40)
            make.top.equalTo(10)
            make.right.equalTo(-20)
        }

        // FloatingBar
        let vc = SearchViewController()
        self.floatingBar.surfaceView.addShadow(direction: .bottom)
        self.floatingBar.surfaceView.cornerRadius = 20.0
        self.floatingBar.show(vc, sender: nil)
        self.floatingBar.track(scrollView: vc.scrollView)
        self.floatingBar.add(toParent: self, belowView: self.menuBarView, animated: true)

        // Scale
        let mapScaleView = MKScaleView(mapView: self.mapView)
        mapScaleView.legendAlignment = .leading
        self.floatingBar.surfaceView.addSubview(mapScaleView)
        mapScaleView.snp.makeConstraints { (make) in
            make.bottom.equalTo(floatingBar.surfaceView.snp.top).offset(-20)
            make.left.equalToSuperview().offset(20)
        }

        // Compass
        // compass define
        self.mapCompassButton = MKCompassButton(mapView: self.mapView)
        mapCompassButton.compassVisibility = .adaptive
        self.view.insertSubview(mapCompassButton, belowSubview: self.floatingBar.surfaceView)
        mapCompassButton.snp.makeConstraints { (make) in
            make.height.width.equalTo(20)
            make.centerX.equalTo(mapTrackingButton)
            make.bottom.equalTo(self.floatingBar.surfaceView.grabberHandle.snp.top).offset(-20)
        }
    }

    // MARK: - Function
    private func updateMapSetting() {
        self.mapView.setUserTrackingMode(.followWithHeading, animated: true)
        self.mapView.mapType = .standard
        self.mapView.showsScale = false
        self.mapView.showsCompass = false
        self.mapView.showsTraffic = true
        self.mapView.showsBuildings = true
        self.mapView.showsUserLocation = true
        self.mapView.showsPointsOfInterest = true
    }

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

    private func updatedFloatingBar(_ vc: FloatingPanelController) {
        let keyFrame = (vc.surfaceView.frame.origin.y - vc.originYOfSurface(for: .full)) / (vc.originYOfSurface(for: .half) - vc.originYOfSurface(for: .full))
        print(keyFrame)
        if vc.originYOfSurface(for: .half) > vc.surfaceView.frame.origin.y {
            UIView.animate(withDuration: 0.5) {
                self.floatingBar.surfaceView.grabberHandle.alpha = keyFrame
                self.floatingBar.surfaceView.cornerRadius = (keyFrame) * 20
                self.mapCompassButton.alpha = keyFrame
            }
        } else {
            UIView.animate(withDuration: 0.5) {
                self.floatingBar.surfaceView.grabberHandle.alpha = 1.0
                self.floatingBar.surfaceView.cornerRadius = 20
                self.mapCompassButton.alpha = 1.0
            }
        }

        if vc.position == .tip {
            UIView.animate(withDuration: 0.5, animations: {
                self.searchButton.alpha = 1.0
            })
        }
    }

    // MARK: - Action
    @objc private func tappedScreen(recognizer: UITapGestureRecognizer) {
        self.floatingBar.move(to: .tip, animated: true) {
            UIView.animate(withDuration: 0.5, animations: {
                self.searchButton.alpha = 1.0
            })
        }
    }

    @objc private func tappedSideMenuButton() {
        openLeft()
    }

    @objc private func tappedSearchButton() {
        self.floatingBar.move(to: .half, animated: true) {
            UIView.animate(withDuration: 0.5, animations: {
                self.searchButton.alpha = 0.0
            })
        }
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

// MARK: - Extantion
extension HomeViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view?.isDescendant(of: self.mapView) ?? false {
            return true
        } else {
            return false
        }
    }
}

extension HomeViewController: FloatingPanelControllerDelegate {
    func floatingPanelWillBeginDragging(_ vc: FloatingPanelController) {
        updatedFloatingBar(vc)
    }

    func floatingPanelDidEndDragging(_ vc: FloatingPanelController, withVelocity velocity: CGPoint, targetPosition: FloatingPanelPosition) {
        updatedFloatingBar(vc)
    }

    func floatingPanelWillBeginDecelerating(_ vc: FloatingPanelController) {
        updatedFloatingBar(vc)
    }

    func floatingPanelDidEndDecelerating(_ vc: FloatingPanelController) {
        updatedFloatingBar(vc)
    }

    func floatingPanelDidMove(_ vc: FloatingPanelController) {
        updatedFloatingBar(vc)
    }
}

extension HomeViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations)
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print(status)
    }
}

extension HomeViewController: MKMapViewDelegate {
    func mapViewWillStartLoadingMap(_ mapView: MKMapView) {
        print("load map")
        print(mapView)
    }

    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        print("load map complited")
        print(mapView)

    }

    func mapViewWillStartRenderingMap(_ mapView: MKMapView) {
        print("render map")
        print(mapView)
    }

    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        print("move map")
        print(mapView)
    }


    func mapView(_ mapView: MKMapView, didChange mode: MKUserTrackingMode, animated: Bool) {
        print("move user")
        print(mode.rawValue)
        print(animated)
    }
}
