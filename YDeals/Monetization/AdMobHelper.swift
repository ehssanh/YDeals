//
//  File.swift
//  YDeals
//
//  Created by msndev on 2019-07-04.
//  Copyright © 2019 SolidXpert. All rights reserved.
//

import Foundation
import GoogleMobileAds

#if canImport(AppTrackingTransparency)
import AppTrackingTransparency
import AdSupport
#endif

class AdMobHelper : NSObject, GADBannerViewDelegate, GADAdLoaderDelegate {
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
    
    var bannerReadyClosure : ((GADBannerView?) -> Void)?
    
    var banner : GADBannerView!
    
    override init() {
        super.init();
        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = [ GADSimulatorID ]
    }
    
    static func initializeMobileAds() {
        if #available(iOS 14.5, *) {
            ATTrackingManager.requestTrackingAuthorization { Status in
                GADMobileAds.sharedInstance().start(completionHandler: nil)
            }
        } else {
            GADMobileAds.sharedInstance().start(completionHandler: nil)
        }
    }
    
    func showBannerAd(rootViewController:UIViewController, whenBannerReady: @escaping ((_ banner:GADBannerView?)->Void)){
        
        self.bannerReadyClosure = whenBannerReady ;
        let adRequest = GADRequest();
        
        let windowWidth = UIApplication.shared.windows[0].frame.width;
        banner = GADBannerView(adSize: GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(windowWidth));
        banner.rootViewController = rootViewController
        banner.delegate = self;
        
        #if DEBUG
        //adRequest.testDevices = ["7883c3684f16cdae7b8475185196ecdf" ];
        banner.adUnitID = testUnitId.banner.rawValue;
        //banner.adUnitID = testUnitId.banner.rawValue;
        #else
        banner.adUnitID = BANNER_AD_UNIT_ID;
        #endif
        
        banner.load(adRequest);
    }
    
    //MARK: -
    //MARK: Google Ad Interstitial Delegate Methods
    func showInterstitial(rootViewController:UIViewController) -> Void {
        let adRequest = GADRequest();
        GADInterstitialAd.load(withAdUnitID: INTERSTITIAL_AD_UNIT_ID,
                               request: adRequest) { interstitial, error in
            if let _ = error {
                return
            }
            
            if let interstitial = interstitial {
                interstitial.present(fromRootViewController: rootViewController)
            }
        }
    }
    
    func showNativeAd(rootViewController:UIViewController, numberOfAds:Int) -> Void {
        let multipleAdsOptions = GADMultipleAdsAdLoaderOptions()
        multipleAdsOptions.numberOfAds = 5
        
        let adLoader = GADAdLoader(adUnitID: "ca-app-pub-3940256099942544/3986624511",
                                   rootViewController: rootViewController,
                                   adTypes: [.native],
                                   options: [multipleAdsOptions])
        adLoader.delegate = self
        
        adLoader.load(GADRequest())
    }
    
    //MARK: -
    //MARK: Google Ad Banner View Delegate Methods
    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
        self.bannerReadyClosure?(bannerView);
    }
    
    /// Tells the delegate an ad request failed.
    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
        self.bannerReadyClosure?(nil);
    }
    
    func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: Error) {
        self.bannerReadyClosure?(nil);
    }
}
