//
//  AdSettings.swift
//  YDeals
//
//  Created by msndev on 2019-07-03.
//  Copyright © 2019 SolidXpert. All rights reserved.
//

import Foundation

class AdSettings : Codable {
    var provider : String
    var appId : String
    var bannerAdId : String
    var interstitialAdId : String
    
}

class AdMobAdSettings : AdSettings{
    
}
