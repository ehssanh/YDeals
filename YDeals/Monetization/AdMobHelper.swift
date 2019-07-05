//
//  File.swift
//  YDeals
//
//  Created by msndev on 2019-07-04.
//  Copyright © 2019 SolidXpert. All rights reserved.
//

import Foundation
import GoogleMobileAds

class AdMobHelper : NSObject, GADBannerViewDelegate {
    
    let ADMOB_APP_ID = "ca-app-pub-9566147283740852~3233547782";
    let BANNER_AD_UNIT_ID = "ca-app-pub-9566147283740852/2598536238";
    let INTERSTITIAL_AD_UNIT_ID = "ca-app-pub-9566147283740852/2902197683";
    
    enum testUnitId : String {
        case banner = "ca-app-pub-3940256099942544/6300978111"
        case interstitial = "ca-app-pub-3940256099942544/1033173712"
        case interstitialVideo = "ca-app-pub-3940256099942544/8691691433"
        case rewardedVideo = "ca-app-pub-3940256099942544/5224354917"
        case nativeAdvanced = "ca-app-pub-3940256099942544/2247696110"
        case nativeAdvancedVideo = "ca-app-pub-3940256099942544/1044960115"
    }
    
    var rootViewController : UIViewController
    var bannerReadyClosure : ((GADBannerView?) -> Void)?
    
    var banner : GADBannerView!
    
    init(with rvc:UIViewController) {
        self.rootViewController = rvc;
        super.init();
    }
    
    func showBannerAd(whenBannerReady: @escaping ((_ banner:GADBannerView?)->Void)){
        
        self.bannerReadyClosure = whenBannerReady ;
        let adRequest = GADRequest();
        
        banner = GADBannerView(adSize: GADAdSizeFromCGSize(CGSize(width: self.rootViewController.view.bounds.width, height: 50.0)));
        banner.rootViewController = self.rootViewController;
        banner.delegate = self;
        #if DEBUG
        adRequest.testDevices = [ kGADSimulatorID ];
        banner.adUnitID = testUnitId.banner.rawValue;
        #else
        banner.adUnitID = BANNER_AD_UNIT_ID;
        #endif
        banner.load(adRequest);
    }
    
    //MARK: -
    //MARK: Google Ad Banner View Delegate Methods
    
    /// Tells the delegate an ad request loaded an ad.
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        self.bannerReadyClosure?(bannerView);
    }
    
    /// Tells the delegate an ad request failed.
    func adView(_ bannerView: GADBannerView,
                didFailToReceiveAdWithError error: GADRequestError) {
        self.bannerReadyClosure?(nil);
    }
    
    /// Tells the delegate that a full-screen view will be presented in response
    /// to the user clicking on an ad.
    func adViewWillPresentScreen(_ bannerView: GADBannerView) {
        print("adViewWillPresentScreen")
    }
    
    /// Tells the delegate that the full-screen view will be dismissed.
    func adViewWillDismissScreen(_ bannerView: GADBannerView) {
        print("adViewWillDismissScreen")
    }
    
    /// Tells the delegate that the full-screen view has been dismissed.
    func adViewDidDismissScreen(_ bannerView: GADBannerView) {
        print("adViewDidDismissScreen")
    }
    
    /// Tells the delegate that a user click will open another app (such as
    /// the App Store), backgrounding the current app.
    func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
        print("adViewWillLeaveApplication")
    }
    
    
}
