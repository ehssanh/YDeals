//
//  WebDetailViewController.swift
//  YDeals
//
//  Created by msndev on 2019-05-15.
//  Copyright © 2019 SolidXpert. All rights reserved.
//

import UIKit
import WebKit

class WebDetailViewController: BaseViewController, WKNavigationDelegate {

    @IBOutlet weak var webView: WKWebView!
    
    private var pageTitle : String?
    private var url : URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if (self.url != nil){
            let request = URLRequest(url: self.url!);
            showUIBusy();
            self.webView.load(request);
            self.webView.navigationDelegate = self;
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        self.showNavBar(true, withTitle: self.pageTitle);
    }
    
    func loadPage(url:String, withtitle title:String){
        self.url = URL(string: url);
        self.pageTitle = title;
    }
    
    //MARK: Web View Nav delegates
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.hideUIBusy();
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.hideUIBusy();
    }
}
