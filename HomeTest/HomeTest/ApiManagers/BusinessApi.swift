//
//  BusinessApi.swift
//  HomeTest
//
//  Created by Duong Pham on 13/02/2022.
//

import Foundation
import Moya

enum BusinessApi {
    case searchBusiness(keyword: String)
}

extension BusinessApi: TargetType {
    var path: String {
        switch self {
        case .searchBusiness:
            return "search"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var task: Task {
        return .requestPlain
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    var baseURL: URL {
        guard let url = URL(string: "https://api.yelp.com/v3/businesses/") else { fatalError("baseURL could not be configured.")}
                return url
    }
    
}


