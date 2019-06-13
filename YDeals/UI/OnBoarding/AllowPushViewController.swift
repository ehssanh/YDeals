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
                print("TOKEN WAS NIL ")
                self.navigateToNext(withData: nil);
                return;
            }
            
            //TODO: Send token to Server, save it
            self.navigateToNext(withData: nil);
            
            #if DEBUG
            let tokenStr = String(data: token!, encoding: .utf8)
            print("TOKEN RECEIVED : \(tokenStr!)")
            #endif
        }
    }
    


}
