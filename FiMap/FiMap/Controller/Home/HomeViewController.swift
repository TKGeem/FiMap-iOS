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
import ZFRippleButton

class HomeViewController: UIViewController {
    // MARK: - Property
    private let mapView = MKMapView()
    private let bottomMenuBarView = UIView()
    private let searchBarView = UIView()

    private let searchTxf = CustomTextField()
    private let searchButton = ZFRippleButton()
    private let sideMenuButton = ZFRippleButton()
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

        NotificationCenter.default.removeObserver(self,
                                                  name: Constants.Notification.SEARCH_SELECT,
                                                  object: nil)
    }

    private func initSetting() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(mapViewMovePointNotification(notification:)),
                                               name: Constants.Notification.SEARCH_SELECT,
                                               object: nil)

        self.view.clipsToBounds = true
        self.view.backgroundColor = Constants.Color.NORMAL_WHITE

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
        self.bottomMenuBarView.backgroundColor = Constants.Color.NORMAL_WHITE
        self.bottomMenuBarView.addShadow(direction: .bottom)
        self.bottomMenuBarView.snp.makeConstraints { (make) in
            make.bottom.centerX.width.equalToSuperview()
            make.height.equalTo(self.parent!.view.safeAreaInsets.bottom + 60)
        }

        // SearchButton
        self.bottomMenuBarView.addSubview(self.searchButton)
        self.searchButton.trackTouchLocation = true
        self.searchButton.rippleColor = Constants.Color.SHADOW.withAlphaComponent(0.1)
        self.searchButton.rippleBackgroundColor = Constants.Color.CLEAR
        self.searchButton.tintColor = Constants.Color.IMAGE_COLOR
        self.searchButton.backgroundColor = Constants.Color.NORMAL_WHITE
        self.searchButton.adjustsImageWhenHighlighted = false
        self.searchButton.layer.cornerRadius = 30
        self.searchButton.setImage(R.image.round_search_black_48pt(), for: .normal)
        self.searchButton.imageEdgeInsets = .init(top: 9, left: 9, bottom: 9, right: 9)
        self.searchButton.isHiddenWithAlpha = 1.0
        self.searchButton.addTarget(self, action: #selector(tappedSearchButton), for: .touchUpInside)
        self.searchButton.addShadow(direction: .bottom)
        self.searchButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.height.width.equalTo(60)
            make.top.equalToSuperview().offset(-10)
        }


        // SideMenu
        self.bottomMenuBarView.addSubview(self.sideMenuButton)
        self.sideMenuButton.trackTouchLocation = true
        self.sideMenuButton.rippleOverBounds = true
        self.sideMenuButton.rippleColor = Constants.Color.SHADOW.withAlphaComponent(0.1)
        self.sideMenuButton.rippleBackgroundColor = Constants.Color.CLEAR
        self.sideMenuButton.tintColor = Constants.Color.IMAGE_COLOR
        self.sideMenuButton.backgroundColor = Constants.Color.CLEAR
        self.sideMenuButton.adjustsImageWhenHighlighted = false
        self.sideMenuButton.setImage(R.image.round_menu_black_48pt(), for: .normal)
        self.sideMenuButton.addTarget(self, action: #selector(tappedSideMenuButton), for: .touchUpInside)
        self.sideMenuButton.snp.makeConstraints { (make) in
            make.height.width.equalTo(35)
            make.top.equalTo(10)
            make.left.equalTo(20)
        }

        // Tracking
        self.mapTrackingButton = MKUserTrackingButton(mapView: self.mapView)
        self.bottomMenuBarView.addSubview(self.mapTrackingButton)
        self.mapTrackingButton.tintColor = Constants.Color.NORMAL_WHITE
        self.mapTrackingButton.backgroundColor = Constants.Color.IMAGE_COLOR
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
        self.mapCompassButton.compassVisibility = .visible
        self.mapCompassButton.isUserInteractionEnabled = true
        self.mapCompassButton.snp.makeConstraints { (make) in
            make.height.width.equalTo(20)
            make.top.equalTo(mapView).offset(50)
            make.right.equalTo(-20)

        }
    }

    private func mapToolLayoutSetting() {
        // FloatingBar
        let vc = SearchViewController()
        self.floatingBar.delegate = self
        //        self.floatingBar.setOverrideTraitCollection(UITraitCollection(verticalSizeClass: .compact), forChild: self)
        self.floatingBar.surfaceView.addShadow(direction: .bottom)
        self.floatingBar.surfaceView.grabberHandle.backgroundColor = Constants.Color.CLEAR
        self.floatingBar.surfaceView.cornerRadius = 20.0
        self.floatingBar.show(vc, sender: nil)
        self.floatingBar.track(scrollView: vc.tableView)
        //self.floatingBar.add(toParent: self, belowView: self.bottomMenuBarView, animated: true)
    }

    private func searchBarViewLayoutSetting() {
        self.view.addSubview(self.searchBarView)
        self.searchBarView.backgroundColor = Constants.Color.LIGHT_GREEN
        self.searchBarView.addShadow(direction: .bottom)
        self.searchBarView.isHiddenWithAlpha = 0.0
        self.searchBarView.snp.makeConstraints { (make) in
            make.top.width.centerX.equalToSuperview()
            make.height.equalTo(self.parent!.view.safeAreaInsets.top + 60)
            print(self.parent!.view.safeAreaInsets.top)
        }
        
        print(searchBarView)

        self.hideKeyboardWhenTappedAround()

        self.searchBarView.addSubview(self.searchTxf)
        self.searchTxf.layer.cornerRadius = 5
        self.searchTxf.backgroundColor = Constants.Color.WHITE_GRAY
        self.searchTxf.placeholder = R.string.localized.home_Search_Placeholder()
        self.searchTxf.returnKeyType = .search
        self.searchTxf.clearButtonMode = .whileEditing
        self.searchTxf.delegate = self
        self.searchTxf.addTarget(self, action: #selector(editSearchTxf), for: .editingChanged)
        self.searchTxf.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.bottom.equalTo(-10)
            make.height.equalTo(38)
            make.centerX.equalToSuperview()
        }
    }

    // MARK: - Function
    private func setSearchData(word: String?) {
        if let criteria = word {
            NotificationCenter.default.post(name: Constants.Notification.SEARCH_ENTER, object: nil, userInfo: ["word": criteria])
        }
    }

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
            self.locationManager.requestWhenInUseAuthorization()
        case .restricted:
            self.locationManager.requestWhenInUseAuthorization()
        case .denied:
            self.locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse:
            self.locationManager.requestWhenInUseAuthorization()
        case .authorizedAlways:
            self.locationManager.requestWhenInUseAuthorization()
        }
    }

    private func updatedFloatingBar(_ vc: FloatingPanelController) {
        self.dismissKeyboard()
        let keyFrame = (vc.surfaceView.frame.origin.y - vc.originYOfSurface(for: .full)) / (100 - vc.originYOfSurface(for: .full))
        if vc.originYOfSurface(for: .half) > vc.surfaceView.frame.origin.y && keyFrame > 0.0 && keyFrame < 1.0 {
            //Non Full
            changeFloatingBar(handleAlpha: keyFrame, barAlpha: 1 - keyFrame, surfaceRadius: (keyFrame) * 20)
        } else if keyFrame > 0.0 && keyFrame < 1.0 {
            //Full
            changeFloatingBar(handleAlpha: 1.0, barAlpha: 1 - keyFrame, surfaceRadius: (keyFrame) * 20)
        } else {
            if keyFrame <= 0.0 {
                // Non Full
                changeFloatingBar(handleAlpha: 0.0, barAlpha: 1.0, surfaceRadius: 0.0) {
                    self.searchTxf.becomeFirstResponder()
                }
            } else {
                // Full
                changeFloatingBar(handleAlpha: 1.0, barAlpha: 0.0, surfaceRadius: 20)
            }
            if vc.position == .tip {
                closeFoatingBar()
            }
        }
    }

    private func openFloatingBar() {
        self.floatingBar.add(toParent: self, belowView: self.bottomMenuBarView, animated: true)
        UIView.animate(withDuration: 0.3, animations: {
            self.floatingBar.surfaceView.grabberHandle.isHiddenWithAlpha = 1.0
            self.floatingBar.surfaceView.cornerRadius = 20.0
            self.searchBarView.isHiddenWithAlpha = 0.0
            self.searchButton.isHiddenWithAlpha = 0.0
        })
    }

    private func closeFoatingBar() {
        self.floatingBar.removeFromParent(animated: true) {
            UIView.animate(withDuration: 0.3, animations: {
                self.searchBarView.isHiddenWithAlpha = 0.0
                self.searchButton.isHiddenWithAlpha = 1.0
            }) { (comp) in
                self.searchTxf.text = ""
                self.setSearchData(word: nil)
            }
        }
    }

    private func changeFloatingBar(handleAlpha: CGFloat, barAlpha: CGFloat, surfaceRadius: CGFloat, animationDuration: Double = 0.3) {
        UIView.animate(withDuration: animationDuration) {
            self.floatingBar.surfaceView.grabberHandle.isHiddenWithAlpha = handleAlpha
            self.searchBarView.isHiddenWithAlpha = barAlpha
            self.floatingBar.surfaceView.cornerRadius = surfaceRadius
        }
    }

    private func changeFloatingBar(handleAlpha: CGFloat, barAlpha: CGFloat, surfaceRadius: CGFloat, animationDuration: Double = 0.3, callback: @escaping () -> ()) {
        UIView.animate(withDuration: animationDuration, animations: {
            self.floatingBar.surfaceView.grabberHandle.isHiddenWithAlpha = handleAlpha
            self.searchBarView.isHiddenWithAlpha = barAlpha
            self.floatingBar.surfaceView.cornerRadius = surfaceRadius
        }) { (comp) in
            callback()
        }
    }

    // MARK: - Action
    @objc private func editSearchTxf() {
        self.setSearchData(word: self.searchTxf.text ?? "")
    }

    @objc private func tappedScreen(recognizer: UITapGestureRecognizer) {
        closeFoatingBar()
    }

    @objc private func tappedSideMenuButton() {
        openLeft()
    }

    @objc private func tappedSearchButton() {
        openFloatingBar()
    }

    @objc private func openSettingView() {
        self.pushNewNavigationController(rootViewController: SettingViewController())
    }

    @objc public func mapViewMovePointNotification(notification: NSNotification) {
        if let point: String = notification.userInfo?["point"] as? String {
            print(point)
        }
        print("-------------")
        closeFoatingBar()
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

extension HomeViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.setSearchData(word: textField.text ?? "")
        self.searchTxf.resignFirstResponder()
        return true
    }
}
