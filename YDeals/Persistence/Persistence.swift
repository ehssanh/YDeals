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
    
    class func save(value:Bool, key:String){
        UserDefaults.standard.set(value, forKey: key);
        UserDefaults.standard.synchronize();
    }
    
    class func save(value:String, key:String){
        UserDefaults.standard.set(value, forKey: key);
        UserDefaults.standard.synchronize();
    }
    
    class func save(value:Int, key:String){
        UserDefaults.standard.set(value, forKey: key);
        UserDefaults.standard.synchronize();
    }
    
    class func save(value:Float, key:String){
        UserDefaults.standard.set(value, forKey: key);
        UserDefaults.standard.synchronize();
    }
    
    class func save(value:Double, key:String){
        UserDefaults.standard.set(value, forKey: key);
        UserDefaults.standard.synchronize();
    }
    
    class func save<T>(value:T?, key:String) where T:Codable{
        
        guard let value = value else{
            return;
        }
        
        do {
            let object = try JSONEncoder().encode(value)
            UserDefaults.standard.set(object, forKey: key);
            UserDefaults.standard.synchronize();
        }catch {
            print(error);
        }
    }
    
    class func load(key:String) -> Any? {
        return UserDefaults.standard.value(forKey: key);
    }
    
    class func load<T>(key:String, type:T.Type) -> T? where T:Codable {
        if let data = UserDefaults.standard.value(forKey: key) as? Data {
            return try? JSONDecoder().decode(T.self, from: data);
        }
        
        return nil;
    }
    
}
