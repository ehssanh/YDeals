//
//  YDealsGateway.swift
//  YDeals
//
//  Created by msndev on 2019-05-13.
//  Copyright © 2019 SolidXpert. All rights reserved.
//

import Foundation

class YDealsGateway: Decodable {
    var enabled : Bool
    var cityName : String
    var gateway : String
    var airportAddress : String
    var url : String
    var siteUrl : String
    
    enum CodingKeys : String, CodingKey{
        case airportAddress = "address"
        case cityName = "city"
        case enabled
        case gateway
        case url
        case siteUrl = "siteurl"
    }
}
