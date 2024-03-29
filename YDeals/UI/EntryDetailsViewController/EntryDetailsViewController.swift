//
//  EntryDetailsViewController.swift
//  YDeals
//
//  Created by Ehssan on 2019-04-13.
//  Copyright © 2019 SolidXpert. All rights reserved.
//

import UIKit
import WebKit
import SafariServices

class EntryDetailsViewController: BaseViewController, WKNavigationDelegate {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var adView: UIView!
    
    private var item : FeedEntry?
    
    private var adHelper : AdMobHelper!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.webView.navigationDelegate = self;
        
        self.view.backgroundColor = APP_BACKGROUND_COLOR;
        
        if let entry = item{
            loadContent(item: entry);
        }
        
        self.adView.isHidden = true;
        self.adHelper = AdMobHelper(with: self);
        self.adHelper.showBannerAd { (bannerView) in
            if bannerView != nil {
                self.adView.isHidden = false;
                self.adView.backgroundColor = APP_BACKGROUND_COLOR;
                self.adView.addSubview(bannerView!);
                bannerView!.backgroundColor = .clear;
                
                self.adView.addConstraint(NSLayoutConstraint(item: bannerView!,
                                                      attribute: .leading,
                                                      relatedBy: .equal,
                                                      toItem: self.adView,
                                                      attribute: .leading,
                                                      multiplier: 1,
                                                      constant: 0))
                
                self.adView.addConstraint(NSLayoutConstraint(item: bannerView!,
                                                      attribute: .trailing,
                                                      relatedBy: .equal,
                                                      toItem: self.adView,
                                                      attribute: .trailing,
                                                      multiplier: 1,
                                                      constant: 0))

                self.adView.addConstraint(NSLayoutConstraint(item: bannerView!,
                                                      attribute: .bottom,
                                                      relatedBy: .equal,
                                                      toItem: self.adView,
                                                      attribute: .bottom,
                                                      multiplier: 1,
                                                      constant: 0))
                
                self.adView.addConstraint(NSLayoutConstraint(item: bannerView!,
                                                             attribute: .top,
                                                             relatedBy: .equal,
                                                             toItem: self.adView,
                                                             attribute: .top,
                                                             multiplier: 1,
                                                             constant: 0))
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        showNavBar(true);
    }
    
    func loadItem(item:FeedEntry) -> Void {
        self.item = item;
    }
    
    private func loadContent(item:FeedEntry){
        
        showShareButton();
        showUIBusy();
        self.image.lazyLoadFromUrl(url: item.imageUrl);
        let htmlString = "<html><head><meta name=\"viewport\" content=\"width=device-width, initial-scale=1\"></head><body style=\"font-family:Helvetica\"><p>"
            + "<h2>\(item.title ?? "")</h2>"
            + "<div style=\"color:#A9A9A9;text-color:#A9A9A9;\"><hr>\(self.dateToString(date: item.publishedDate))<hr></div>"
            + "\(item.htmlContent ?? "")</p></body></html>";
        
        let baseUrl = "https://" + (URL(string: item.link!)?.host)! ;
        webView.loadHTMLString(htmlString, baseURL: URL(string: baseUrl)!);
        
    }
    
    func dateToString(date:Date?) -> String{
        //       2019-03-28T14:19:50-06:00
        guard let date = date else {
            return "";
        }
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_CA");
        formatter.dateFormat = "EEEE, YYYY MMMM dd"
        return formatter.string(from: date)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        hideUIBusy();
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        hideUIBusy();
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        guard let linkUrl = navigationAction.request.url else {
            decisionHandler(.allow);
            return;
        }
        
        if (linkUrl.absoluteString.contains("/go/")){
            let svc = SFSafariViewController(url: linkUrl)
            svc.preferredBarTintColor = APP_BACKGROUND_COLOR;
            svc.preferredControlTintColor = .white;
            svc.modalPresentationStyle = .overFullScreen
            self.present(svc, animated: true, completion: nil)
            decisionHandler(.cancel)
        }else{
            decisionHandler(.allow);
        }
    }
    
    func showShareButton() -> Void{
        let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action:#selector(EntryDetailsViewController.onShareButtonPressed));
        self.navigationItem.rightBarButtonItem = shareButton;
    }
    
    @objc
    func onShareButtonPressed(){
        let appLink = "http://itunes.apple.com/us/app/YTravelDeals/id" + (Bundle.main.infoDictionary!["CFBundleIdentifier"] as! String);
        guard let title = item?.title, let image = self.image.image else{
            return;
        }
        
        let shareItem : [Any] = [ title , appLink, image];
        let activityController  = UIActivityViewController(activityItems: shareItem, applicationActivities: nil);
        self.present(activityController, animated: true)
    }
}
