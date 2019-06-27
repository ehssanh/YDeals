//
//  AllowPushViewController.swift
//  YDeals
//
//  Created by msndev on 2019-05-09.
//  Copyright © 2019 SolidXpert. All rights reserved.
//

import UIKit

class AllowPushViewController: OnboardingSequenceElement {

    private var notificationHandler : NotificationHandler?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.notificationHandler = (UIApplication.shared.delegate as! AppDelegate).notificationHandler;
    }
    
    @IBAction func onAllowPushButtonClicked(_ sender: Any) {
        
        guard let notificationHandler = self.notificationHandler else {
            navigateToNext(withData: nil);
            return;
        }
        
        notificationHandler.registerForPush { (token, error) in
            
            if error != nil {
                print(error?.localizedDescription ?? "");
                self.navigateToNext(withData: nil);
                return;
            }
            
            if token == nil {
                Utilities.dLog(message: "TOKEN WAS NIL ")
                self.navigateToNext(withData: nil);
                Persistence.save(value: nil, key: PERSISTENCE_KEY_DEVICE_TOKEN);
                return;
            }

            let tokenStr = token!.map { String(format: "%2.2hhx", $0) }.joined()
            Persistence.save(value: tokenStr, key: PERSISTENCE_KEY_DEVICE_TOKEN);
            
            Utilities.dLog(message: "TOKEN RECEIVED : \(tokenStr)");
            
            //TODO: Send token to Server, save it
            self.navigateToNext(withData: tokenStr);
        }
    }
    


}
