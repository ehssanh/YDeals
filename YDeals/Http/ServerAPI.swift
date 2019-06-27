//
//  ServerAPI.swift
//  YDeals
//
//  Created by msndev on 2019-06-27.
//  Copyright © 2019 SolidXpert. All rights reserved.
//

import Foundation

class ServerAPI {
    
    let REGISTER_DEVICE_ENDPOINT = "registerdevice";
    let UPDATE_AIRPORT_ENDPOINT = "updateairport";
    
    let HTTP_OK_STATUS_CODE = 200;
    
    func registerDevice(deviceToken:String, airport:String, whenCompleted onSuccess:@escaping ((Bool)->Void)){
    
        var composedUrl = BACKEND_BASE_URL + "/";
        composedUrl += REGISTER_DEVICE_ENDPOINT + "?";
        composedUrl += "platform=ios";
        composedUrl += "&dt=\(deviceToken)";
        composedUrl += "&airport=\(airport)";
        
        let regDeviceUrl = URL(string: composedUrl)!
        
        let task = URLSession.shared.dataTask(with: regDeviceUrl) { (data, response, error) in
            if (error != nil){
                onSuccess(false);
                return;
            }
            
            if (response==nil || data==nil){
                onSuccess(false);
                return;
            }
            
            let statusCode = (response as! HTTPURLResponse).statusCode;
            if (statusCode != self.HTTP_OK_STATUS_CODE){
                onSuccess(false);
                return;
            }
            
            //otherwise assume ok
            onSuccess(true);
            
        };
        
        task.resume();
    }
}
