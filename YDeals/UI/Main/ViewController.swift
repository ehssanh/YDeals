//
//  ViewController.swift
//  YDeals
//
//  Created by Ehssan on 2019-04-09.
//  Copyright © 2019 SolidXpert. All rights reserved.
//

import UIKit

class ViewController: BaseInfiniteViewController, FeedPresenterDelegate {

    @IBOutlet weak var collectionView: InfiniteCollectionView!
    @IBOutlet weak var gatewayName: UILabel!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    
    private var parser : GenericFeedParser!
    private var presenter : FeedPresenter!
    private var airport : YDealsGateway!
    private var currentFeed : Feed?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView();
        setupButtons();
        
        
        //TODO: Use data provider based on User option to
        let feedUrl = URL(string: self.airport.url)!;
        self.gatewayName?.text = self.airport.gateway + " Deals";
        
        self.parser = FeedkitParser(feedUrl: feedUrl);
        self.presenter = FeedPresenter(parser:self.parser, delegate: self);
        self.showUIBusy();
        self.presenter.present();
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.showNavBar(false);
    }
    
    func setupButtons(){
        //Settings
        self.settingsButton.addTarget(self, action: #selector(onSettingsButtonClicked), for: UIControl.Event.touchUpInside);
        //Search
        self.searchButton.addTarget(self, action: #selector(onSearchButtonClicked), for: UIControl.Event.touchUpInside)
        //Search button UI
        self.searchButton.layer.shadowColor = UIColor.white.cgColor
        self.searchButton.layer.shadowOpacity = 1
        self.searchButton.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.searchButton.layer.shadowRadius = 10
    }
    
    @objc func onSearchButtonClicked() -> Void{
        
    }
    
    @objc func onSettingsButtonClicked() -> Void{
        let _ = self.navigateTo(xibName: "SettingsViewController", clazzType: SettingsViewController.self, initBlock: nil);
    }
    
    public func setYDealsGateway(_ gateway:YDealsGateway){
        self.airport = gateway
    }
    
    override func refreshViewController() {
        self.showUIBusy();
        self.presenter.present();
    }
    
    
    private func setupCollectionView() -> Void {
        self.collectionView.setupCollectionView(with: self);
    }
    
    //MARK: PresenterDelegate
    func presenterReadyToPresent(item:Feed?, error:Error?) {
        hideUIBusy();
        
        if let err = error {
            //TODO : Show a meaningful Error
            print(err.localizedDescription);
            return;
        }
        
        //First time
        guard let feed = item, feed.entries != nil else{
            print("Fatal Err - No feed loaded.");
            return;
        }
        
        //Feed ready to be presented.
        if (self.currentFeed == nil){
            self.collectionView.reloadEntries(entries: feed.entries);
            self.currentFeed = item;
        }else{
            //load more
            self.collectionView.appendEntries(entries: feed.entries)
            self.currentFeed = item;
            self.collectionView.reloadData();
        }
    }

    override func loadMore(){
        let nextLink = self.currentFeed?.nextFeedLink
        guard let nextFeedLink = nextLink else{
            hideUIBusy();
            return;
        }
        
        showUIBusy();
        self.parser.updateUrl(feedUrl: URL(string: nextFeedLink)!);
        self.presenter.present();
    }
}

