//
//  AppDelegate.swift
//  YDeals
//
//  Created by Ehssan on 2019-04-09.
//  Copyright © 2019 SolidXpert. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    static let onboardingController = OnboardingController()
    var notificationHandler : NotificationHandler?
    
    private var isAppUpdated : Bool = false;
    private var application : UIApplication!

    //----------------------------------------------------
    //MARK: -
    //MARK: App Lifecycle
    //----------------------------------------------------
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.application = application;
        
        let args = ProcessInfo.processInfo.arguments
        if args.contains("UI_TEST_MODE") {
            Persistence.save(value: false, key: PERSISTENCE_KEY_ONBOARDING_DONE);
        }

        self.isAppUpdated = checkAppVersionForUpdate();
        if (self.isAppUpdated){
            let updateOnboardingSequence = [PrivacyPolicyViewController.self, PickAirportViewController.self]
            AppDelegate.onboardingController.updateMode();
            AppDelegate.onboardingController.setOnboardingSequence(newSequence: updateOnboardingSequence);
            
        }

        self.notificationHandler = NotificationHandler(application);
        
        let rootVC = determineInitialViewController();
        self.window?.rootViewController = setupNavigationController(rootVC);
        self.window?.makeKeyAndVisible();
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        self.notificationHandler?.didRegisterForRemoteNotificationsWithDeviceToken(deviceToken: deviceToken, error:nil);
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        self.notificationHandler?.didRegisterForRemoteNotificationsWithDeviceToken(deviceToken: nil, error:error);
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        self.notificationHandler?.didReceiveRemoteNotification(userInfo: userInfo, fetchCompletionHandler: completionHandler);
    }
 
    //----------------------------------------------------
    //MARK: -
    //MARK: Public Methods
    //----------------------------------------------------
    private func determineInitialViewController() -> UIViewController {
        return UIStoryboard(name: "SpalshScreen", bundle: nil).instantiateInitialViewController()!;
    }
    
    func setupNavigationController(_ rootVC:UIViewController) -> UINavigationController{
        let navCtrl = UINavigationController(rootViewController: rootVC);
        return navCtrl;
    }
    
    func getAppVersion() -> String {
        let versionNumber = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        let buildNumber = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String
        return versionNumber + "." + buildNumber;
    }
    
    
    //----------------------------------------------------
    //MARK: -
    //MARK: Private Methods
    //----------------------------------------------------
    
    private func checkAppVersionForUpdate() -> Bool{
        let version = getAppVersion();
        let lastSavedVersion = Persistence.load(key: PERSISTENCE_KEY_APP_VERSION) as! String?
        Persistence.save(value: version, key: PERSISTENCE_KEY_APP_VERSION);
        
        if (lastSavedVersion == nil){
            return false; // First install is not an update
        }else if (lastSavedVersion != version){
            return true;
        }
        
        print(version);
        return false;
    }

}

