//
//  ViewController.swift
//  YDeals
//
//  Created by Ehssan on 2019-04-09.
//  Copyright © 2019 SolidXpert. All rights reserved.
//

import UIKit

class ViewController: BaseViewController, FeedPresenterDelegate, EntryCollectionViewDelegateCallback {

    @IBOutlet weak var collectionView: InfiniteCollectionView!
    private var collectionViewDelegate : EntryCollectionViewDelegate?;
    private var collectionViewDataSource : EntryCollectionViewDataSource?;
    
    //private var dataProvider : DataProvider<Feed>
    private var parser : GenericFeedParser!
    private var presenter : FeedPresenter!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView();
        
        // Do any additional setup after loading the view, typically from a nib.
        let feedUrl = URL(string: "https://www.yvrdeals.com/atom/1");
        self.parser = FeedkitParser(feedUrl: feedUrl!);
        self.presenter = FeedPresenter(parser:self.parser, delegate: self);
        self.showUIBusy();
        self.presenter.present();
    }
    
    func setupCollectionView() -> Void {
        
        self.collectionViewDataSource = EntryCollectionViewDataSource(entries: [FeedEntry]());
        self.collectionViewDelegate = EntryCollectionViewDelegate(callback: self);
        self.collectionView.dataSource = collectionViewDataSource;
        self.collectionView.delegate = collectionViewDelegate;
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 1
        flowLayout.minimumInteritemSpacing = 0
        self.collectionView.collectionViewLayout = flowLayout;
        
        let nib = UINib(nibName: "EntryCollectionViewCell", bundle: Bundle.main);
        self.collectionView.register(nib, forCellWithReuseIdentifier: EntryCollectionViewDataSource.CELL_REUSE_ID);
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
        
        self.collectionViewDataSource?.reloadEntries(entries: feed.entries!);
        self.collectionView.reloadData();
    }
    
    func itemClicked(feedEntry: FeedEntry) {
        let vc = EntryDetailsViewController(nibName: "EntryDetailsViewController", bundle: Bundle.main)
        vc.loadItem(item: feedEntry)
        self.navigationController?.pushViewController(vc, animated: true)
        
    }

}

