//
//  WiFiPoint.swift
//  FiMap
//
//  Created by El You on 2018/12/02.
//  Copyright © 2018 ammYou. All rights reserved.
//

// To parse the JSON, add this file to your project and do:
//
//   let wifi = try WifiPoint(json)
//
// To read values from URLs:
//
//   let task = URLSession.shared.wifiTask(with: url) { wifi, response, error in
//     if let wifi = wifi {
//       ...
//     }
//   }
//   task.resume()
//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseWifi { response in
//     if let wifi = response.result.value {
//       ...
//     }
//   }

import Foundation
import Alamofire

class WifiPoint: Codable {
    let datas: [WifiData]?
    let statusCode: Int?
    let statusMsg: String?
    
    enum CodingKeys: String, CodingKey {
        case datas
        case statusCode = "status_code"
        case statusMsg = "status_msg"
    }
    
    init(datas: [WifiData]?, statusCode: Int?, statusMsg: String?) {
        self.datas = datas
        self.statusCode = statusCode
        self.statusMsg = statusMsg
    }
}

class WifiData: Codable {
    let xGeoPoint, yGeoPoint: Double?
    let address: String?
    let hpURL: String?
    let id: Int?
    let name, postCode, ssid: String?
    
    enum CodingKeys: String, CodingKey {
        case xGeoPoint = "X(geoPoint)"
        case yGeoPoint = "Y(geoPoint)"
        case address
        case hpURL = "hpUrl"
        case id, name, postCode, ssid
    }
    
    init(xGeoPoint: Double?, yGeoPoint: Double?, address: String?, hpURL: String?, id: Int?, name: String?, postCode: String?, ssid: String?) {
        self.xGeoPoint = xGeoPoint
        self.yGeoPoint = yGeoPoint
        self.address = address
        self.hpURL = hpURL
        self.id = id
        self.name = name
        self.postCode = postCode
        self.ssid = ssid
    }
}

// MARK: Convenience initializers and mutators

extension WifiPoint {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(WifiPoint.self, from: data)
        self.init(datas: me.datas, statusCode: me.statusCode, statusMsg: me.statusMsg)
    }
    
    convenience init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
    
    convenience init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }
    
    func with(
        datas: [WifiData]?? = nil,
        statusCode: Int?? = nil,
        statusMsg: String?? = nil
        ) -> WifiPoint {
        return WifiPoint(
            datas: datas ?? self.datas,
            statusCode: statusCode ?? self.statusCode,
            statusMsg: statusMsg ?? self.statusMsg
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension WifiData {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(WifiData.self, from: data)
        self.init(xGeoPoint: me.xGeoPoint, yGeoPoint: me.yGeoPoint, address: me.address, hpURL: me.hpURL, id: me.id, name: me.name, postCode: me.postCode, ssid: me.ssid)
    }
    
    convenience init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
    
    convenience init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }
    
    func with(
        xGeoPoint: Double?? = nil,
        yGeoPoint: Double?? = nil,
        address: String?? = nil,
        hpURL: String?? = nil,
        id: Int?? = nil,
        name: String?? = nil,
        postCode: String?? = nil,
        ssid: String?? = nil
        ) -> WifiData {
        return WifiData(
            xGeoPoint: xGeoPoint ?? self.xGeoPoint,
            yGeoPoint: yGeoPoint ?? self.yGeoPoint,
            address: address ?? self.address,
            hpURL: hpURL ?? self.hpURL,
            id: id ?? self.id,
            name: name ?? self.name,
            postCode: postCode ?? self.postCode,
            ssid: ssid ?? self.ssid
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}

func newJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        encoder.dateEncodingStrategy = .iso8601
    }
    return encoder
}

// MARK: - URLSession response handlers

extension URLSession {
    fileprivate func codableTask<T: Codable>(with url: URL, completionHandler: @escaping (T?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return self.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completionHandler(nil, response, error)
                return
            }
            completionHandler(try? newJSONDecoder().decode(T.self, from: data), response, nil)
        }
    }
    
    func wifiTask(with url: URL, completionHandler: @escaping (WifiPoint?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return self.codableTask(with: url, completionHandler: completionHandler)
    }
}

// MARK: - Alamofire response handlers

extension DataRequest {
    fileprivate func decodableResponseSerializer<T: Decodable>() -> DataResponseSerializer<T> {
        return DataResponseSerializer { _, response, data, error in
            guard error == nil else { return .failure(error!) }
            
            guard let data = data else {
                return .failure(AFError.responseSerializationFailed(reason: .inputDataNil))
            }
            
            return Result { try newJSONDecoder().decode(T.self, from: data) }
        }
    }
    
    @discardableResult
    fileprivate func responseDecodable<T: Decodable>(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<T>) -> Void) -> Self {
        return response(queue: queue, responseSerializer: decodableResponseSerializer(), completionHandler: completionHandler)
    }
    
    @discardableResult
    func responseWifi(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<WifiPoint>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
}
