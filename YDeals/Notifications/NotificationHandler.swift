//
//  NotificationHandle.swift
//  YDeals
//
//  Created by msndev on 2019-06-12.
//  Copyright © 2019 SolidXpert. All rights reserved.
//

import Foundation
import UserNotifications
import UIKit

class NotificationHandler {
    
    private var application : UIApplication
    private var pushRegistrationCompletionBlock : ((_ token:Data?,_ regError:Error?) -> Void)?
    
    init(_ application: UIApplication) {
        self.application = application;
    }
    
    func registerForPush(whenComplete onPushRegistrationCompletion:@escaping (_ token:Data?,_ regError:Error?) -> Void) -> Void {
        
        self.pushRegistrationCompletionBlock = onPushRegistrationCompletion;
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .sound, .alert]) { (notificationPermitted, error) in
            if error != nil{
                onPushRegistrationCompletion(nil, error);
                return;
            }
            
            guard notificationPermitted else {
                onPushRegistrationCompletion(nil, AppError.pushRegisterError.foundationError);
                return;
            }
            
            DispatchQueue.main.async {
                self.application.registerForRemoteNotifications();
                // completion block will be called on didRegisterForRemoteNotificationsWithDeviceToken
            }
        }
    }
    
    
    func didRegisterForRemoteNotificationsWithDeviceToken(deviceToken: Data?, error:Error?){
        if (self.pushRegistrationCompletionBlock != nil){
            self.pushRegistrationCompletionBlock!(deviceToken, error);
        }
    }
    
    func didReceiveRemoteNotification (userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void){
        
    }
    
}
