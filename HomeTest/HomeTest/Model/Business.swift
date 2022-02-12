//
//  Business.swift
//  HomeTest
//
//  Created by Duong Pham on 13/02/2022.
//

import Foundation

struct SearchBusinessResponse: Decodable {
    var businesses: [Business]?
    var total: Int?
}

struct Business: Decodable {
    var imageUrl: String?
    var name: String?
    var location: Location?
    
    enum CodingKeys: String, CodingKey {
        case imageUrl = "image_url"
        case name, location
    }
}

struct Location: Decodable {
    var city: String?
    var country: String?
    var address1: String?
    var address2: String?
    var address3: String?
    var state: String?
    var zipCode: String?
    var displayAddress: String?
    
    enum CodingKeys: String, CodingKey {
        case zipCode = "zip_code"
        case displayAddress = "display_address"
        case city, country, address1, address2, address3, state
    }
}
