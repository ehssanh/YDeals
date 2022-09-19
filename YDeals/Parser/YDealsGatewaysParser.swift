//
//  YDealsGatewaysParser.swift
//  YDeals
//
//  Created by msndev on 2019-05-13.
//  Copyright © 2019 SolidXpert. All rights reserved.
//

import Foundation


class YDealsGatewaysParser: NSObject {
    
    func parse(whenComplete completionBlock: @escaping (_ gateways:[YDealsGateway]? ,_ parseError:Error?) -> Void){

        guard let parseUrl = URL(string: YDEALS_GATEWAY_URL) else {
            completionBlock(nil, NSError(domain: "URL Error", code: 401, userInfo: nil))
            return
        }
        
        let request = URLRequest(url: parseUrl, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 60)
        
        let dataTask = URLSession.shared.dataTask(with: request) { (data, response, err) in
            if err != nil {
                completionBlock(nil, err);
                return;
            }
            
            let httpResponse = response as! HTTPURLResponse
            guard httpResponse.statusCode == 200 else{
                completionBlock(nil, err);
                return;
            }
            
            guard let data = data else {
                completionBlock(nil, err);
                return;
            }
            
            var gateways : [YDealsGateway]?
            var serializationError : Error? = nil
           
            do {
                 gateways = try JSONDecoder().decode([YDealsGateway].self, from: data)
            }catch let serErr{
                gateways = nil;
                serializationError = serErr
            }
            
            completionBlock(gateways, serializationError);
        }
        
        dataTask.resume();
    }
}
