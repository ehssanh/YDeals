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
    
    
    func registerDevice(deviceToken:String, airport:String, whenCompleted onSuccess:@escaping ((_ success:Bool,_ registrationId: Double?)->Void)){
    
        var composedUrl = BACKEND_BASE_URL + "/";
        composedUrl += REGISTER_DEVICE_ENDPOINT + "?";
        composedUrl += "platform=ios";
        composedUrl += "&dt=\(deviceToken)";
        composedUrl += "&airport=\(airport)";
        
        let regDeviceUrl = URL(string: composedUrl)!
        
        let task = URLSession.shared.dataTask(with: regDeviceUrl) { (data, response, error) in
            if (error != nil){
                onSuccess(false, nil);
                return;
            }
            
            if (response==nil || data==nil){
                onSuccess(false, nil);
                return;
            }
            
            let statusCode = (response as! HTTPURLResponse).statusCode;
            if (statusCode != self.HTTP_OK_STATUS_CODE){
                onSuccess(false, nil);
                return;
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String : Any]
                let insertId = json!["result"] as! Double;
                Utilities.dLog(message: "Insertion Id found as \(insertId)");
                
                if ( insertId != 0 ){
                    //Save Registration Id (DB Insert Id / Primary Key) from Server.
                    Persistence.save(value: insertId, key: PERSISTENCE_KEY_REMOTE_REGISTER_ID);
                }
                
                onSuccess(true, insertId)

            }catch {
                Utilities.dLog(message: error.localizedDescription)
                onSuccess(false, nil);
            }
        };
        
        task.resume();
    }
    
    
    func updateAirport(newAirportGateway:String, whenCompleted onSuccess:@escaping ((_ success:Bool,_ registrationId: Double?)->Void)){
        
        let deviceRegistrationId = Persistence.load(key: PERSISTENCE_KEY_REMOTE_REGISTER_ID) as! Double;
        
        var composedUrl = BACKEND_BASE_URL + "/";
        composedUrl += UPDATE_AIRPORT_ENDPOINT + "?";
        composedUrl += "platform=ios";
        composedUrl += "&id=\(String(deviceRegistrationId))";
        composedUrl += "&airport=\(newAirportGateway)";
        
        let regDeviceUrl = URL(string: composedUrl)!
        
        let task = URLSession.shared.dataTask(with: regDeviceUrl) { (data, response, error) in
            if (error != nil){
                onSuccess(false, nil);
                return;
            }
            
            if (response==nil || data==nil){
                onSuccess(false, nil);
                return;
            }
            
            let statusCode = (response as! HTTPURLResponse).statusCode;
            if (statusCode != self.HTTP_OK_STATUS_CODE){
                onSuccess(false, nil);
                return;
            }
            
            
        }
        task.resume();
    }
    
    
    func updateGatewayLastDeal(gateway:YDealsGateway, feed:Feed?){
        
    }
    
}
