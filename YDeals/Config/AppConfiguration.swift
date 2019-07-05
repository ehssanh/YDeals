//
//  AppConfiguration.swift
//  YDeals
//
//  Created by msndev on 2019-07-03.
//  Copyright © 2019 SolidXpert. All rights reserved.
//

import Foundation


struct AppConfiguration : Codable {
    var version : String
    var adsEnabled : Bool
    
    enum CodingKeys : String, CodingKey{
        case version
        case adsEnabled = "ads_enabled"
    }
    
}

