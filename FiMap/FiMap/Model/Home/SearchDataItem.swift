//
//  SearchDataItem.swift
//  FiMap
//
//  Created by El You on 2018/12/02.
//  Copyright © 2018 ammYou. All rights reserved.
//

import Foundation



class SearchDataItem: NSObject {
    enum CategoryType {
        case Near
    }
    
    public var title = [String]()
    
    public func getSearchCategory(){
        self.title.append("WiFi(T)")
    }
}
