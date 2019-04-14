//
//  EntryDetailsViewController.swift
//  YDeals
//
//  Created by Ehssan on 2019-04-13.
//  Copyright © 2019 SolidXpert. All rights reserved.
//

import UIKit
import WebKit

class EntryDetailsViewController: BaseViewController, WKNavigationDelegate {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var webView: WKWebView!
    
    private var item : FeedEntry?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.webView.navigationDelegate = self;
        
        if let entry = item{
            loadContent(item: entry);
        }
    }
    
    func loadItem(item:FeedEntry) -> Void {
        self.item = item;
    }
    
    private func loadContent(item:FeedEntry){
        showUIBusy();
        self.image.lazyLoadFromUrl(url: item.imageUrl);
        webView.loadHTMLString("<html><head><meta name=\"viewport\" content=\"width=320, initial-scale=1\"></head><body style=\"font-family:Helvetica\"><p>"+"<h2>\(item.title ?? "")</h2>"+"\(item.htmlContent ?? "")</p></body></html>", baseURL: nil);
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        hideUIBusy();
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        hideUIBusy();
    }
}
