//
//  SearchDataItem.swift
//  FiMap
//
//  Created by El You on 2018/12/02.
//  Copyright © 2018 ammYou. All rights reserved.
//

import Foundation
import Alamofire

class SearchDataSource: NSObject {
    enum CategoryType {
        case Near
    }

    public var searchTitle = [String]()
    public var searchData = [WifiData]()

    public func getSearchCategory(_ callback: @escaping () -> ()) {
        self.searchTitle.removeAll()
        self.searchTitle.append("WiFi(T)")
        callback()
    }

    public func searchWifiData(searchWord: String, _ callback: @escaping () -> ()) {
        let url = "\(Constants.Url.API_ENDPOINT)\(Constants.Url.Wifi.GET_POINTS)"
        let param = ["name": searchWord]
        var title: [String] = [String]()
        var data: [WifiData] = [WifiData]()

        Alamofire.request(url,
                          method: .get,
                          parameters: param).responseWifi { response in
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
        }

    }
}
