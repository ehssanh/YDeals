//
//  YDealsGatewaysParser.swift
//  YDeals
//
//  Created by msndev on 2019-05-13.
//  Copyright © 2019 SolidXpert. All rights reserved.
//

import Foundation

class YDealsGatewaysParser: NSObject {
    let parseUrl = URL(string: YDEALS_GATEWAY_URL)!;
    
    func parse(whenComplete completionBlock: @escaping (_ gateways:[YDealsGateway]? ,_ parseError:Error?) -> Void){
        let dataTask = URLSession.shared.dataTask(with: parseUrl) { (data, response, err) in
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
                 print(gateways);
            }catch let serErr{
                gateways = nil;
                serializationError = serErr
            }
            
            completionBlock(gateways, serializationError);
        }
        
        dataTask.resume();
    }
}
