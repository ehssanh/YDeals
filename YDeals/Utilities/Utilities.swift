//
//  File.swift
//  YDeals
//
//  Created by msndev on 2019-05-10.
//  Copyright © 2019 SolidXpert. All rights reserved.
//

import Foundation
import UIKit

struct Utilities {
    
    static func showError(_ errorMessage:String, parent:UIViewController?){
        showAlert(title: "Error", message: errorMessage, parent: parent);
    }
    
    static func showLog(_ errorMessage:String, parent:UIViewController?){
        #if DEBUG
        dLog(message: errorMessage)
        #endif
    }
    
    static func showAlert(title:String, message:String, parent:UIViewController?){
        guard let parent = parent else{
            return;
        }
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert);
        let ok = UIAlertAction(title: "Ok", style: .cancel) { (alertAction) in
            // noop
        }
        
        alertController.addAction(ok);
        parent.present(alertController, animated: true, completion: nil);
    }
    
    // dLog and aLog macros to abbreviate NSLog.
    // Use like this:
    //
    //   dLog("Log this!")
    //
    #if DEBUG
    static func dLog(message: String, filename: String = #file, function: String = #function, line: Int = #line) {
        NSLog("[\(URL(fileURLWithPath: filename).lastPathComponent):\(line)] \(function) - \(message)")
    }
    #else
    static func dLog(message: String, filename: String = #file, function: String = #function, line: Int = #line) {
    }
    #endif
    static func aLog(message: String, filename: String = #file, function: String = #function, line: Int = #line) {
        NSLog("[\(URL(fileURLWithPath: filename).lastPathComponent):\(line)] \(function) - \(message)")
    }
}
