//
//  AllowPushViewController.swift
//  YDeals
//
//  Created by msndev on 2019-05-09.
//  Copyright © 2019 SolidXpert. All rights reserved.
//

import UIKit
import UserNotifications

class AllowPushViewController: OnboardingSequenceElement {

    private var notificationHandler : NotificationHandler?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 10.0, *) {
            let current = UNUserNotificationCenter.current()
            current.getNotificationSettings(completionHandler: { settings in
                
                DispatchQueue.main.async {
                    self.notificationHandler = (UIApplication.shared.delegate as! AppDelegate).notificationHandler;
                    let deviceToken = Persistence.load(key: PERSISTENCE_KEY_DEVICE_TOKEN) as! String?;
                    
                    if (deviceToken != nil){
                        self.navigateToNext(withData: nil);
                        return;
                    }
                    
                    switch(settings.authorizationStatus){
                        
                    case .notDetermined:
                        break;
                    case .denied, .authorized, .provisional:
                        self.navigateToNext(withData: nil);
                        return;
                    @unknown default:
                        self.navigateToNext(withData: nil);
                        break;
                    }
                }
            })
        }
    }
    
    @IBAction func onAllowPushButtonClicked(_ sender: Any) {
        
        guard let notificationHandler = self.notificationHandler else {
            navigateToNext(withData: nil);
            return;
        }
        
        notificationHandler.registerForPush { (token, error) in
            
            if error != nil {
                print(error?.localizedDescription ?? "");
                Persistence.save(value: nil, key: PERSISTENCE_KEY_DEVICE_TOKEN);
                self.navigateToNext(withData: nil);
                return;
            }
            
            if token == nil {
                Utilities.dLog(message: "TOKEN WAS NIL ")
                Persistence.save(value: nil, key: PERSISTENCE_KEY_DEVICE_TOKEN);
                self.navigateToNext(withData: nil);
                return;
            }

            let tokenStr = token!.map { String(format: "%2.2hhx", $0) }.joined()
            Persistence.save(value: tokenStr, key: PERSISTENCE_KEY_DEVICE_TOKEN);
            Utilities.dLog(message: "TOKEN RECEIVED : \(tokenStr)");
            
            //TODO: Send token to Server, save it
            self.navigateToNext(withData: tokenStr);
        }
    }
    
    @IBAction func onNoThanksButtonPushed(_ sender: Any) {
        Persistence.save(value: nil, key: PERSISTENCE_KEY_DEVICE_TOKEN);
        self.navigateToNext(withData: nil);
        return;
    }
    

}
