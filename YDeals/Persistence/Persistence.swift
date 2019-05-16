//
//  Persistence.swift
//  YDeals
//
//  Created by msndev on 2019-05-15.
//  Copyright © 2019 SolidXpert. All rights reserved.
//

import Foundation

class Persistence {
    
    class func save(value:Any?, key:String){
        UserDefaults.standard.set(value, forKey: key);
        UserDefaults.standard.synchronize();
    }
    
    class func save<T>(value:T?, key:String) where T:Codable{
        let object = try? PropertyListEncoder().encode(value!)
        UserDefaults.standard.set(object, forKey: key);
        UserDefaults.standard.synchronize();
    }
    
    class func load(key:String) -> Any? {
        return UserDefaults.standard.value(forKey: key);
    }
    
    class func load<T>(value:T?, key:String) -> T? where T:Codable {
        if let data = UserDefaults.standard.value(forKey: key) as? Data {
            return try? PropertyListDecoder().decode(T.self, from: data);
        }
        
        return nil;
    }
    
}
