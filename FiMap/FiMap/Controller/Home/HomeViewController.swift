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

enum FloatBarMode {
    case search
    case infomation
}

class HomeViewController: UIViewController {
    // MARK: - Property
    private let mapView = MKMapView()
    private let bottomMenuBarView = UIView()
    private let searchBarView = UIView()
    private let resultBarView = UIView()


    private let searchTxf = CustomTextField()
    private let resultLabel = UILabel()
    private let searchButton = ZFRippleButton()
    private let sideMenuButton = ZFRippleButton()
    private var mapCompassButton: MKCompassButton!
    private var mapTrackingButton: MKUserTrackingButton!
    private var mapScaleView: MKScaleView!

    private let floatingBar = FloatingPanelController()
    private let searchViewController = SearchViewController()
    private let infomationViewController = InfomationViewController()

    public let locationManager = CLLocationManager()

    public var dataSource = SearchDataSource()

    private var floatBarVC = FloatBarMode.search


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
        resultBarViewLayoutSetting()
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
        NotificationCenter.default.removeObserver(self,
                                                  name: Constants.Notification.DISSMISS_KEYBOARD,
                                                  object: nil)
    }

    private func initSetting() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(mapViewMovePointNotification(notification:)),
                                               name: Constants.Notification.SEARCH_SELECT,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(openSettingView),
                                               name: Constants.Notification.SETTING_OPEN,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.dismissKeyboard),
                                               name: Constants.Notification.DISSMISS_KEYBOARD,
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

        updateMapViewAnnotaion()
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
        let vc = self.searchViewController
        self.floatingBar.delegate = self
        //self.floatingBar.setOverrideTraitCollection(UITraitCollection(verticalSizeClass: .compact), forChild: self)
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
        }

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

    private func resultBarViewLayoutSetting() {
        self.view.addSubview(self.resultBarView)
        self.resultBarView.backgroundColor = Constants.Color.LIGHT_GREEN
        self.resultBarView.addShadow(direction: .bottom)
        self.resultBarView.isHiddenWithAlpha = 0.0
        self.resultBarView.snp.makeConstraints { (make) in
            make.top.width.centerX.equalToSuperview()
            make.height.equalTo(self.parent!.view.safeAreaInsets.top + 60)
        }

        self.resultBarView.addSubview(self.resultLabel)
        self.resultLabel.backgroundColor = UIColor.clear
        self.resultLabel.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.bottom.equalTo(-10)
            make.height.equalTo(38)
            make.centerX.equalToSuperview()
        }
    }

    // MARK: - Function
    private func addAnnotationsFromDatas(datas: [WifiData], afterRemove: Bool = false, withSelect: Bool = false) {

        var annotations = [MKPointAnnotation]()
        for data in datas {
            let annotation = MKPointAnnotation()
            annotation.title = data.name
            annotation.subtitle = "SSID: \(data.ssid ?? "")"
            annotation.coordinate = CLLocationCoordinate2DMake(data.yGeoPoint ?? 0.0, data.xGeoPoint ?? 0.0)
            annotations.append(annotation)
            self.mapView.addAnnotation(annotation)
        }
        if afterRemove {
//            self.mapView.removeAnnotations(self.mapView.annotations)
        }
        if annotations.count != 0 {
            print("added \(annotations.count) count")
            print(self.mapView.annotations.count)
//            self.mapView.addAnnotations(annotations)
        }
        if withSelect {
//            self.mapView.selectAnnotation(annotation, animated: true)
        }
    }

    private func showAnnotationsFromDatas(datas: [WifiData] = [WifiData]()) {
        if datas.count != 0 {
            var annotations = [MKPointAnnotation]()
            let annotation = MKPointAnnotation()
            for data in datas {
                annotation.title = data.name
                annotation.subtitle = "SSID: \(data.ssid ?? "")"
                annotation.coordinate = CLLocationCoordinate2DMake(data.yGeoPoint ?? 0.0, data.xGeoPoint ?? 0.0)
                annotations.append(annotation)
            }
            if annotations.count != 0 {
                self.mapView.showAnnotations(annotations, animated: true)
            }
        } else {
            print(self.mapView.annotations.count)
            self.mapView.showAnnotations(self.mapView.annotations, animated: false)
        }
    }

    private func selectAnnotationFromData(data: WifiData) {
        let annotation = MKPointAnnotation()
        annotation.coordinate =  CLLocationCoordinate2DMake(data.yGeoPoint ?? 0.0, data.xGeoPoint ?? 0.0)
        annotation.title = data.name
        annotation.subtitle = "SSID: \(data.ssid ?? "")"
        let filteredAnnotation = self.mapView.annotations.first { (conAnnotation) -> Bool in
            conAnnotation.title == annotation.title &&
            conAnnotation.subtitle == annotation.subtitle
        }
        
        if let annotation = filteredAnnotation {
            self.mapView.setCenter(annotation.coordinate, animated: true)
            self.mapView.selectAnnotation(annotation, animated: true)
        }else{
            self.mapView.setCenter(annotation.coordinate, animated: true)
            addAnnotationsFromDatas(datas: [data], afterRemove: false, withSelect: true)
        }
        
    }

    private func setSearchData(word: String?) {
        NotificationCenter.default.post(name: Constants.Notification.SEARCH_ENTER, object: nil, userInfo: [Constants.NotificationInfo.WORD: word ?? ""])
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
        case .restricted, .denied:
            break
        case .authorizedAlways, .authorizedWhenInUse:
            break
        }
    }

    private func updatedFloatingBar(_ vc: FloatingPanelController) {
        let keyFrame = (vc.surfaceView.frame.origin.y - vc.originYOfSurface(for: .full)) / (100 - vc.originYOfSurface(for: .full))
        if vc.originYOfSurface(for: .half) > vc.surfaceView.frame.origin.y && keyFrame > 0.0 && keyFrame < 1.0 {
            // Down when Full
            self.dismissKeyboard()
            changeFloatingBar(handleAlpha: keyFrame, barAlpha: 1 - keyFrame, surfaceRadius: (keyFrame) * 20)
        } else if keyFrame > 0.0 && keyFrame < 1.0 {
            // No call
            changeFloatingBar(handleAlpha: 1.0, barAlpha: 1 - keyFrame, surfaceRadius: (keyFrame) * 20)
        } else {
            // Half to Full
            if keyFrame <= 0.0 {
                //When Full
                if self.floatBarVC == .search {
                    self.searchTxf.becomeFirstResponder()
                }
                changeFloatingBar(handleAlpha: 0.0, barAlpha: 1.0, surfaceRadius: 0.0)
            } else {
                changeFloatingBar(handleAlpha: 1.0, barAlpha: 0.0, surfaceRadius: 20)
            }

            if vc.position == .tip {
                closeFoatingBar {

                }
            }
        }
    }

    private func openFloatingBar(_ callback: @escaping () -> ()) {
        switch self.floatBarVC {
        case .infomation:
            self.floatingBar.show(self.infomationViewController, sender: nil)
            self.floatingBar.track(scrollView: self.infomationViewController.tableView)
        case .search:
            self.floatingBar.show(self.searchViewController, sender: nil)
            self.floatingBar.track(scrollView: self.searchViewController.tableView)
        }

        self.floatingBar.add(toParent: self, belowView: self.bottomMenuBarView, animated: true)
        UIView.animate(withDuration: 0.3, animations: {
            self.floatingBar.surfaceView.grabberHandle.isHiddenWithAlpha = 1.0
            self.floatingBar.surfaceView.cornerRadius = 20.0
            self.searchBarView.isHiddenWithAlpha = 0.0
            self.resultBarView.isHiddenWithAlpha = 0.0
            self.searchButton.isHiddenWithAlpha = 0.0
            callback()
        })
    }

    private func closeFoatingBar(_ callback: @escaping () -> ()) {
        self.floatingBar.removeFromParent(animated: true) {
            UIView.animate(withDuration: 0.3, animations: {
                self.searchBarView.isHiddenWithAlpha = 0.0
                self.resultBarView.isHiddenWithAlpha = 0.0
                self.searchButton.isHiddenWithAlpha = 1.0
            }) { (comp) in
                self.searchTxf.text = ""
                self.setSearchData(word: "")
                self.floatBarVC = .search
                callback()
            }
        }
    }

    private func changeFloatingBar(handleAlpha: CGFloat, barAlpha: CGFloat, surfaceRadius: CGFloat, animationDuration: Double = 0.2) {
        UIView.animate(withDuration: animationDuration) {
            self.floatingBar.surfaceView.grabberHandle.isHiddenWithAlpha = handleAlpha
            self.floatingBar.surfaceView.cornerRadius = surfaceRadius
            switch self.floatBarVC {
            case .search:
                self.searchBarView.isHiddenWithAlpha = barAlpha
            case .infomation:
                self.resultBarView.isHiddenWithAlpha = barAlpha
            }
        }
    }

    private func changeFloatingBar(handleAlpha: CGFloat, barAlpha: CGFloat, surfaceRadius: CGFloat, animationDuration: Double = 0.3, callback: @escaping () -> ()) {
        UIView.animate(withDuration: animationDuration, animations: {
            self.floatingBar.surfaceView.grabberHandle.isHiddenWithAlpha = handleAlpha
            self.floatingBar.surfaceView.cornerRadius = surfaceRadius
            switch self.floatBarVC {
            case .search:
                self.searchBarView.isHiddenWithAlpha = barAlpha
            case .infomation:
                self.resultBarView.isHiddenWithAlpha = barAlpha
            }
        }) { (comp) in
            callback()
        }
    }

    private func updateMapViewAnnotaion() {
        let mRect = mapView.visibleMapRect
        let centerMapPoint = MKMapPoint(x: mRect.midX, y: mRect.midY)
        let bottomMapPoint = MKMapPoint(x: mRect.midX, y: mRect.minY)
        let currentDist = centerMapPoint.distance(to: bottomMapPoint)

        self.dataSource.getWifiData() {
            self.addAnnotationsFromDatas(datas: self.dataSource.searchData, afterRemove: true)
//            self.showAnnotationsFromDatas()
        }
    }

    private func changeFloatBarViewController(mode: FloatBarMode) {
    }

    // MARK: - Action
    @objc private func editSearchTxf() {
        self.setSearchData(word: self.searchTxf.text ?? "")
    }

    @objc private func tappedScreen(recognizer: UITapGestureRecognizer) {
        closeFoatingBar({ })
    }

    @objc private func tappedSideMenuButton() {
        openLeft()
    }

    @objc private func tappedSearchButton() {
        openFloatingBar({ })
    }

    @objc private func openSettingView() {
        self.pushNewNavigationController(rootViewController: SettingViewController())
    }

    @objc public func mapViewMovePointNotification(notification: NSNotification) {
        if let point: WifiData = notification.userInfo?[Constants.NotificationInfo.DATA] as? WifiData {
            print(point)
            selectAnnotationFromData(data: point)
        }

        print("-------------")

        closeFoatingBar {
            self.floatBarVC = .infomation
            self.openFloatingBar({ })
        }
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
//        print(locations)
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        print(status)
    }
}

//MARK: MKMapViewDelegate
extension HomeViewController: MKMapViewDelegate {
    func mapViewWillStartLoadingMap(_ mapView: MKMapView) {
//        print("load map")
//        print(mapView)
    }

    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
//        print("load map complited")
//        print(mapView)

    }

    func mapViewWillStartRenderingMap(_ mapView: MKMapView) {
//        print("render map")
//        print(mapView)
    }

    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
//        print("move map")
//        print(mapView)
    }

    func mapView(_ mapView: MKMapView, didChange mode: MKUserTrackingMode, animated: Bool) {
//        print("move user")
//        print(mode.rawValue)
//        print(animated)
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "wifi"

//        if annotation.isKind(of: MKUserLocation.self) {
//            return nil
//        }

        // Reuse the annotation if possible
        var annotationView: MKMarkerAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView

        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        }

        annotationView?.glyphImage = R.image.baseline_wifi_white_48pt()
        annotationView?.markerTintColor = Constants.Color.LIGHT_GREEN
        annotationView?.animatesWhenAdded = true
        annotationView?.canShowCallout = true
        annotationView?.clusteringIdentifier = "wifi"

        return annotationView
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print(view.annotation?.coordinate)
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        // どのピンがタップされたかを取得
        let title = view.annotation?.title

        if let point = title { // "optional(横浜)"となるので、アンラップする http://qiita.com/maiki055/items/b24378a3707bd35a31a8
            let place = "hello " + point!
            print(place)
        }
    }

    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
    }
}

extension HomeViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.setSearchData(word: textField.text ?? "")
        self.searchTxf.resignFirstResponder()
        return true
    }
}
