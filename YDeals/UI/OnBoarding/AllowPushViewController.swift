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

        //self.notificationHandler = (UIApplication.shared.delegate as! AppDelegate).notificationHandler;
        self.notificationHandler = nil;
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
                print("TOKEN WAS NIL ")
                self.navigateToNext(withData: nil);
                return;
            }
           
            #if DEBUG
            
            let tokenStr = token!.map { String(format: "%2.2hhx", $0) }.joined()
            print("TOKEN RECEIVED : \(tokenStr)")
            #endif
            
            //TODO: Send token to Server, save it
            self.navigateToNext(withData: nil);
        }
    }
    


}
