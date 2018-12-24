//
//  SearchDataItem.swift
//  FiMap
//
//  Created by El You on 2018/12/02.
//  Copyright © 2018 ammYou. All rights reserved.
//

import Foundation

class SearchDataSource: NSObject {
    enum CategoryType {
        case Near
    }
    
    public var searchTitle = [String]()
    
    public func getSearchCategory(){
        self.searchTitle.removeAll()
        self.searchTitle.append("WiFi(T)")
    }
}
