//
//  ViewController.swift
//  YDeals
//
//  Created by Ehssan on 2019-04-09.
//  Copyright © 2019 SolidXpert. All rights reserved.
//

import UIKit

class ViewController: BaseViewController, FeedPresenterDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    private var collectionViewDelegate : EntryCollectionViewDelegate?;
    private var collectionViewDataSource : EntryCollectionViewDataSource?;
    
    //private var dataProvider : DataProvider<Feed>
    private var parser : GenericFeedParser!
    private var presenter : FeedPresenter!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionViewDataSource = EntryCollectionViewDataSource(entries: [FeedEntry]());
        self.collectionViewDelegate = EntryCollectionViewDelegate();
        self.collectionView.dataSource = collectionViewDataSource;
        self.collectionView.delegate = collectionViewDelegate;
        
        let nib = UINib(nibName: "EntryCollectionViewCell", bundle: Bundle.main);
        self.collectionView.register(nib, forCellWithReuseIdentifier: EntryCollectionViewDataSource.CELL_REUSE_ID)
        //self.collectionView.register(EntryCollectionViewCell.self, forCellWithReuseIdentifier: EntryCollectionViewDataSource.CELL_REUSE_ID);
        
        // Do any additional setup after loading the view, typically from a nib.
        let feedUrl = URL(string: "https://www.yvrdeals.com/atom/1");
        self.parser = FeedkitParser(feedUrl: feedUrl!);
        self.presenter = FeedPresenter(parser:self.parser, delegate: self);
        self.presenter.present();
        
    }

    func presenterReadyToPresent(item:Feed?, error:Error?) {
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

}

