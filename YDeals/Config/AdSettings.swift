//
//  AdSettings.swift
//  YDeals
//
//  Created by msndev on 2019-07-03.
//  Copyright © 2019 SolidXpert. All rights reserved.
//

import Foundation

struct AdSettings : Codable {
    var provider : String
    var appId : String
    var bannerAdId : String
    var interstitialAdId : String
    
    let ADMOB_APP_ID = "ca-app-pub-9566147283740852~3233547782";
    let BANNER_ID = "ca-app-pub-9566147283740852/2598536238";
    let INTERSTITIAL_ID = "ca-app-pub-9566147283740852/2902197683";

    
}
