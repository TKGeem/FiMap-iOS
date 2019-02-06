//
//  SearchDataItem.swift
//  FiMap
//
//  Created by El You on 2018/12/02.
//  Copyright © 2018 ammYou. All rights reserved.
//

import Foundation
import Alamofire
import MapKit
import SVProgressHUD

class SearchDataSource: NSObject {
    enum CategoryType {
        case Near
    }

    public var searchTitle = [String]()
    public var searchData = [WifiData]()
    private var isPorccess = false

    public func getSearchCategory(_ callback: @escaping () -> ()) {
        self.searchTitle.removeAll()
        self.searchTitle.append("付近のWiFi")
        callback()
    }

    public func searchWifiData(word: String, _ callback: @escaping () -> ()) {
        if self.isPorccess {
            return
        }
        self.isPorccess = true

        let url = "\(Constants.Url.API_ENDPOINT)\(Constants.Url.Wifi.GET_POINTS)"
        let param = ["name": word]
        var title: [String] = [String]()
        var data: [WifiData] = [WifiData]()

        Alamofire.request(url,
                          method: .get,
                          parameters: param).responseWifi { response in
            if response.response?.statusCode == 200 {
                if let wifi = response.result.value {
                    if let wifiDatas = wifi.datas {
                        data = wifiDatas
                        for data in wifiDatas {
                            title.append(data.name ?? "")
                        }
                        self.searchTitle = title
                        self.searchData = data
                    }
                }
                callback()
            } else {
                SVProgressHUD.showError(withStatus: "失敗 \(response.response?.statusCode ?? 000)")
            }
            self.isPorccess = false
        }
    }

    public func getWifiData(_ callback: @escaping () -> ()) {
        if self.isPorccess {
            return
        }
        self.isPorccess = true
        SVProgressHUD.show(withStatus: "データを取得中")
        let url = "\(Constants.Url.API_ENDPOINT)\(Constants.Url.Wifi.GET_POINTS)"
        var title: [String] = [String]()
        var data: [WifiData] = [WifiData]()
        Alamofire.request(url,
                          method: .get).responseWifi { response in
            SVProgressHUD.dismiss()
            if response.response?.statusCode == 200 {
                SVProgressHUD.showSuccess(withStatus: "完了)")
                if let wifi = response.result.value {
                    if let wifiDatas = wifi.datas {
                        data = wifiDatas
                        for data in wifiDatas {
                            title.append(data.name ?? "")
                        }
                        self.searchTitle = title
                        self.searchData = data
                    }
                }
                callback()
            } else {
                callback()
                SVProgressHUD.showError(withStatus: "失敗 \(response.response?.statusCode ?? 000)")
            }
            self.isPorccess = false
        }
    }

    public func searchWifiData(location: CLLocationCoordinate2D, distance: Double, force: Bool = false,_ callback: @escaping () -> ()) {
        if self.isPorccess && !force {
            return
        }

        self.isPorccess = true
        let url = "\(Constants.Url.API_ENDPOINT)\(Constants.Url.Wifi.GET_POINTS)"
        let param = ["latitude": location.latitude, "longitude": location.longitude, "distance": distance]
        var title: [String] = [String]()
        var data: [WifiData] = [WifiData]()

        Alamofire.request(url,
                          method: .get,
                          parameters: param).responseWifi { response in
            if response.response?.statusCode == 200 {
                if let wifi = response.result.value {
                    if let wifiDatas = wifi.datas {
                        data = wifiDatas
                        for data in wifiDatas {
                            title.append(data.name ?? "")
                        }
                        self.searchTitle = title
                        self.searchData = data
                    }
                }
                callback()
            } else {
                callback()
                SVProgressHUD.showError(withStatus: "失敗 \(response.response?.statusCode ?? 000)")
            }
            self.isPorccess = false
        }

    }
}
