//
//  ErrorCode.swift
//  YDeals
//
//  Created by msndev on 2019-06-12.
//  Copyright © 2019 SolidXpert. All rights reserved.
//

import Foundation

enum AppError {
    
    case pushRegisterError
    case locationPermissionDeniedError
    
    
    private var domain : String{
        return "com.solidxpert.traveldealserrorDomain";
    }
    
    private var code : Int{
        switch self {
        
        case .pushRegisterError:
            return 1001;
        case .locationPermissionDeniedError:
            return 2001;
        }
    }
    
    var description : String{
        switch self {
        case .pushRegisterError:
            return "Error registering for push notification"
        case .locationPermissionDeniedError:
            return "Location Permission denied or refused"
        }
        
    }
    
    var foundationError: NSError {
        return NSError(domain: domain, code: code, userInfo: [NSLocalizedDescriptionKey : description])
    }
    
}
