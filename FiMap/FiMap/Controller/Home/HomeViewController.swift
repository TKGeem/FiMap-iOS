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
    private let bottomMenuBarView = UIView()
    private let searchBarView = UIView()

    private let searchButton = UIButton()
    private let sideMenuButton = UIButton()
    private var mapCompassButton: MKCompassButton!
    private var mapTrackingButton: MKUserTrackingButton!
    private var mapScaleView: MKScaleView!

    private let floatingBar = FloatingPanelController()
    private let searchViewController = SearchViewController()
    private let infomationViewController = InformationViewController()

    public let locationManager = CLLocationManager()

    // MARK: - Override
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }

    override func loadView() {
        super.loadView()
        mapViewLayoutSetting()
        menuBarLayoutSetting()
        mapToolLayoutSetting()
        searchBarViewLayoutSetting()
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
        self.view.clipsToBounds = true
        self.view.backgroundColor = UIColor.white

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
        self.mapView.delegate = self
    }

    private func menuBarLayoutSetting() {
        // MenuBar
        self.view.addSubview(self.bottomMenuBarView)
        self.bottomMenuBarView.backgroundColor = Constants.Color.LIGHT_GARY
        self.bottomMenuBarView.addShadow(direction: .bottom)
        self.bottomMenuBarView.snp.makeConstraints { (make) in
            make.bottom.centerX.width.equalToSuperview()
            make.height.equalTo(self.parent!.view.safeAreaInsets.bottom + 60)
        }

        // SearchButton
        self.bottomMenuBarView.addSubview(self.searchButton)
        self.searchButton.backgroundColor = Constants.Color.LIGHT_GARY
        self.searchButton.layer.cornerRadius = 30
        self.searchButton.setImage(R.image.search_icon(), for: .normal)
        self.searchButton.imageEdgeInsets = .init(top: 9, left: 9, bottom: 9, right: 9)
        self.searchButton.alpha = 1.0
        self.searchButton.addTarget(self, action: #selector(tappedSearchButton), for: .touchUpInside)
        self.searchButton.addShadow(direction: .bottom)
        self.searchButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.height.width.equalTo(60)
            make.top.equalToSuperview().offset(-20)
        }

        // SideMenu
        self.bottomMenuBarView.addSubview(self.sideMenuButton)
        self.sideMenuButton.setImage(R.image.menu_icon(), for: .normal)
        self.sideMenuButton.addTarget(self, action: #selector(tappedSideMenuButton), for: .touchUpInside)
        self.sideMenuButton.snp.makeConstraints { (make) in
            make.height.width.equalTo(35)
            make.top.equalTo(10)
            make.left.equalTo(20)
        }

        // Tracking
        self.mapTrackingButton = MKUserTrackingButton(mapView: self.mapView)
        self.bottomMenuBarView.addSubview(self.mapTrackingButton)
        self.mapTrackingButton.tintColor = Constants.Color.LIGHT_GARY
        self.mapTrackingButton.backgroundColor = Constants.Color.FIMAP_THEME
        self.mapTrackingButton.layer.cornerRadius = 5
        self.mapTrackingButton.addShadow(direction: .bottom)
        self.mapTrackingButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(40)
            make.top.equalTo(10)
            make.right.equalTo(-20)
        }

        // Scale
        self.mapScaleView = MKScaleView(mapView: self.mapView)
        self.bottomMenuBarView.addSubview(self.mapScaleView)
        self.mapScaleView.legendAlignment = .leading
        self.mapScaleView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.bottom.equalTo(self.bottomMenuBarView.snp.top).offset(-10)
        }

        // Compass
        self.mapCompassButton = MKCompassButton(mapView: self.mapView)
        self.bottomMenuBarView.addSubview(self.mapCompassButton)
        self.mapCompassButton.compassVisibility = .adaptive
        self.mapCompassButton.snp.makeConstraints { (make) in
            make.height.width.equalTo(20)
            make.top.equalTo(additionalSafeAreaInsets.top).offset(200)
            make.left.equalToSuperview().offset(20)
        }
    }

    private func mapToolLayoutSetting() {
        // FloatingBar
        let vc = SearchViewController()
        self.floatingBar.delegate = self
//        self.floatingBar.setOverrideTraitCollection(UITraitCollection(verticalSizeClass: .compact), forChild: self)
        self.floatingBar.surfaceView.addShadow(direction: .bottom)
        self.floatingBar.surfaceView.grabberHandle.backgroundColor = UIColor.clear
        self.floatingBar.surfaceView.cornerRadius = 20.0
        self.floatingBar.show(vc, sender: nil)
        self.floatingBar.track(scrollView: vc.collectionView)
        //self.floatingBar.add(toParent: self, belowView: self.bottomMenuBarView, animated: true)
    }

    private func searchBarViewLayoutSetting() {
        self.view.addSubview(self.searchBarView)
        self.searchBarView.backgroundColor = Constants.Color.LIGHT_GARY
        self.searchBarView.addShadow(direction: .bottom)
        self.searchBarView.alpha = 0.0
        self.searchBarView.snp.makeConstraints { (make) in
            make.top.width.centerX.equalToSuperview()
            make.height.equalTo(self.parent!.view.safeAreaInsets.top + 50)
            print(self.parent!.view.safeAreaInsets.top)
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
        let keyFrame = (vc.surfaceView.frame.origin.y - vc.originYOfSurface(for: .full)) / (100 - vc.originYOfSurface(for: .full))
        let animationDuration = 0.3
        print(keyFrame)
        if vc.originYOfSurface(for: .half) > vc.surfaceView.frame.origin.y && keyFrame > 0.0 && keyFrame < 1.0 {
            UIView.animate(withDuration: animationDuration) {
                self.floatingBar.surfaceView.grabberHandle.alpha = keyFrame
                self.floatingBar.surfaceView.cornerRadius = (keyFrame) * 20
                self.searchBarView.alpha = 1 - keyFrame
            }
        } else if keyFrame > 0.0 && keyFrame < 1.0 {
            UIView.animate(withDuration: animationDuration) {
                self.floatingBar.surfaceView.grabberHandle.alpha = 1.0
                self.floatingBar.surfaceView.cornerRadius = (keyFrame) * 20
                self.searchBarView.alpha = 1 - keyFrame
            }
        } else {
            if keyFrame <= 0.0 {
                UIView.animate(withDuration: animationDuration, animations: {
                    self.floatingBar.surfaceView.grabberHandle.alpha = 0.0
                    self.searchBarView.alpha = 1.0
                }) { (comp) in
                    self.floatingBar.surfaceView.cornerRadius = 0
                }
            } else {
                UIView.animate(withDuration: animationDuration, animations: {
                    self.floatingBar.surfaceView.grabberHandle.alpha = 1.0
                    self.searchBarView.alpha = 0.0
                }) { (comp) in
                    self.floatingBar.surfaceView.cornerRadius = 20
                }
            }
            if vc.position == .tip {
                self.floatingBar.removeFromParent(animated: true) {
                    UIView.animate(withDuration: 0.5, animations: {
                        self.searchButton.alpha = 1.0
                    })
                }
            }
        }
    }

// MARK: - Action
    @objc private func tappedScreen(recognizer: UITapGestureRecognizer) {
        self.floatingBar.removeFromParent(animated: true) {
            UIView.animate(withDuration: 0.5, animations: {
                self.searchButton.alpha = 1.0
            })
        }
    }

    @objc private func tappedSideMenuButton() {
        openLeft()
    }

    @objc private func tappedSearchButton() {
        self.floatingBar.add(toParent: self, belowView: self.bottomMenuBarView, animated: true)
        UIView.animate(withDuration: 0.5, animations: {
            self.searchButton.alpha = 0.0
        })
    }

    @objc private func openSettingView() {
        self.pushNewNavigationController(rootViewController: SettingViewController(),
                                         animation: .cover(direction: .up))
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

// MARK: FloatingPanelControllerDelegate
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

    func floatingPanel(_ vc: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout? {
        return FloatingBarLayout()
    }

    func floatingPanel(_ vc: FloatingPanelController, behaviorFor newCollection: UITraitCollection) -> FloatingPanelBehavior? {
        return FloatingBarBehavior()
    }
}

// MARK: CLLocationManagerDelegate
extension HomeViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations)
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print(status)
    }
}

//MARK: MKMapViewDelegate
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
