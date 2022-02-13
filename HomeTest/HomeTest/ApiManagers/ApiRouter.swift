//
//  BusinessApi.swift
//  HomeTest
//
//  Created by Duong Pham on 13/02/2022.
//

import Foundation
import Moya
import CoreLocation

enum ApiRouter {
    case searchBusiness(keyword: String, type: SearchType, location: CLLocationCoordinate2D?)
    case getBusinessDetail(id: String)
}

extension ApiRouter: TargetType {
    var baseURL: URL {
        guard let url = URL(string: "https://api.yelp.com/v3/businesses/") else { fatalError("baseURL could not be configured.")}
                return url
    }
    
    var path: String {
        switch self {
        case .searchBusiness:
            return "search"
        case .getBusinessDetail(let id):
            return id
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var task: Task {
        return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
    }
    
    var headers: [String : String]? {
        return ["Authorization": "Bearer \(Constants.apiKey)"]
    }
    
    var parameters: [String: Any] {
        switch self {
        case .searchBusiness(let keyword, let type, let location):
            switch type {
            case .businessName:
                guard let location = location else { return [:] }
                return ["term": keyword,
                        "latitude": location.latitude,
                        "longitude": location.longitude]
            case .location:
                return ["location": keyword]
            case .cuisineType:
                guard let location = location else { return [:] }
                return ["categories": keyword,
                        "latitude": location.latitude,
                        "longitude": location.longitude]
            }
        case .getBusinessDetail:
            return [:]
        }
    }
    
}


