//
//  ViewController.swift
//  YDeals
//
//  Created by Ehssan on 2019-04-09.
//  Copyright © 2019 SolidXpert. All rights reserved.
//

import UIKit

class ViewController: BaseViewController, FeedPresenterDelegate {

    @IBOutlet weak var collectionView: InfiniteCollectionView!
 
    //private var dataProvider : DataProvider<Feed>
    private var parser : GenericFeedParser!
    private var presenter : FeedPresenter!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView();
        
        let feedUrl = URL(string: "https://www.yvrdeals.com/atom/1");
        self.parser = FeedkitParser(feedUrl: feedUrl!);
        self.presenter = FeedPresenter(parser:self.parser, delegate: self);
        self.showUIBusy();
        self.presenter.present();
    }
    
    func setupCollectionView() -> Void {
        self.collectionView.setupCollectionView(with: self);
    }
    
    func presenterReadyToPresent(item:Feed?, error:Error?) {
        hideUIBusy();
        
        if let err = error {
            //TODO : Show a meaningful Error
            print(err.localizedDescription);
            return;
        }        

        //Feed ready to be presented.
        guard let feed = item, feed.entries != nil else{
            print("Fatal Err - No feed loaded.");
            return;
        }
        
        self.collectionView.reloadEntries(entries: feed.entries)
    }

    override func refreshViewController() {
        self.showUIBusy();
        self.presenter.present();
    }
}

