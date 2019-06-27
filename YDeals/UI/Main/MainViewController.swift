//
//  ViewController.swift
//  YDeals
//
//  Created by Ehssan on 2019-04-09.
//  Copyright © 2019 SolidXpert. All rights reserved.
//

import UIKit

class MainViewController: BaseInfiniteViewController, FeedPresenterDelegate, SearchbarViewDelegate {

    @IBOutlet weak var collectionView: InfiniteCollectionView!
    @IBOutlet weak var gatewayName: UILabel!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    
    private var parser : GenericFeedParser!
    private var presenter : FeedPresenter!
    private var airport : YDealsGateway!
    private var currentFeed : Feed?
    
    private var searchBarView : SearchbarView?
    var tapGestureRecognizer : UITapGestureRecognizer?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView();
        setupButtons();
        setupSearchbar();
        
        self.tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onViewTapped))
        
        self.airport = Persistence.load(key: PERSISTENCE_KEY_CURRENT_YDEALS_GATEWAY, type: YDealsGateway.self) ;
        let deviceToken = Persistence.load(key: PERSISTENCE_KEY_DEVICE_TOKEN) as! String?;
        
        if (deviceToken != nil && self.airport != nil){
            
            self.serverAPI.registerDevice(deviceToken: deviceToken!, airport: self.airport.gateway) { (successful, registrationId) in
                if (successful){
                    Utilities.dLog(message: "Registered. DEVICE TOKEN, Airport sent to server.")
                }
            }
        }
        
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
        self.searchBarView?.isHidden = false
        self.collectionView.isUserInteractionEnabled = false;
        self.tapGestureRecognizer?.numberOfTouchesRequired = 1;
        self.view.isUserInteractionEnabled = true;
        self.view.addGestureRecognizer(self.tapGestureRecognizer!);
    }
    
    @objc func onViewTapped() -> Void {
        self.searchBarView?.hideKeyboard();
        self.collectionView.isUserInteractionEnabled = true;
        self.view.removeGestureRecognizer(self.tapGestureRecognizer!);
    }
    
    @objc func onSettingsButtonClicked() -> Void{
        let _ = self.navigateTo(xibName: "SettingsViewController", clazzType: SettingsViewController.self, initBlock: nil);
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
    
    
    //Mark: Searchbar
    private func setupSearchbar(){
        var topPadding : CGFloat = 0
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            topPadding = (window?.safeAreaInsets.top)!;

        }else{
            topPadding = 0;
        }
        
        self.searchBarView = SearchbarView(frame: CGRect(x: 0, y: topPadding + 2, width: self.view.frame.width , height: 49))
        self.searchBarView?.backgroundColor = self.view.backgroundColor;

        self.view.addSubview(self.searchBarView!);
        self.searchBarView?.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true;
        self.searchBarView?.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true;
        self.searchBarView?.delegate = self;
        self.searchBarView?.isHidden = true
    }
    
    func searchTermDidChange(term: String?) {
        guard let term = term, !(term.isEmpty) else {
            return;
        }
        
        self.collectionView.searchFor(keyword: term);
    }
    
    func onActionButtonClicked() {
        self.collectionView.endFiltering();
        self.searchBarView?.isHidden = true;
        self.collectionView.isUserInteractionEnabled = true;
    }
}

