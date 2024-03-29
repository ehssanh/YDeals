//
//  AppSettings.swift
//  YDeals
//
//  Created by msndev on 2019-05-10.
//  Copyright © 2019 SolidXpert. All rights reserved.
//

import Foundation
import UIKit

//Themes and measurement
let APP_BACKGROUND_COLOR : UIColor = UIColor(red256: 26, green: 166, blue: 237, alpha: 1); //1AA6ED
let MAP_ZOOM_DIAMETER_METERS : Double = 140000 //150 km

//URLs and APIs
let BACKEND_BASE_URL = "https://solidxpert.ca/registerdevice";

let YDEALS_GATEWAY_URL = "https://www.solidxpert.com/appdata/traveldeals/traveldeals_ydealsdata.json";
let APP_ABOUT_URL = "https://www.solidxpert.com/appdata/traveldeals/about_travel_deals.html"
let APP_PRIVACY_POLICY_URL = "https://www.solidxpert.com/appdata/traveldeals/privacy_policy.html"
let APP_REMOTE_CONFIG_URL = "https://www.solidxpert.com/appdata/traveldeals/app_configuration.json"


//Notifications
let NOTIFICATION_APP_REFRESH = "NOTIF_APP_ENTERED_FOREGROUND";

//Persistence
let PERSISTENCE_KEY_ONBOARDING_DONE = "P_Onboarding"
let PERSISTENCE_KEY_CURRENT_YDEALS_GATEWAY = "P_Ydeals_Gateway"
let PERSISTENCE_KEY_APP_VERSION = "P_App_Ver"
let PERSISTENCE_KEY_PRIVACY_CONSENT = "P_Privacy_Consent"
let PERSISTENCE_KEY_DEVICE_TOKEN = "P_APNS_DeviceToken"
let PERSISTENCE_KEY_REMOTE_REGISTER_ID = "P_Rem_APNS_RegId"




