//
//  InfiniteCollectionView.swift
//  YDeals
//
//  Created by Ehssan on 2019-04-13.
//  Copyright © 2019 SolidXpert. All rights reserved.
//

import UIKit

class InfiniteCollectionView: UICollectionView, EntryCollectionViewDelegateCallback{
    
    private var controller : BaseViewController?
    private var collectionViewDelegate : EntryCollectionViewDelegate?;
    private var collectionViewDataSource : EntryCollectionViewDataSource?;
    
    func setupCollectionView(with controller:BaseViewController?) -> Void {
        
        self.controller = controller;
        
        self.collectionViewDataSource = EntryCollectionViewDataSource(entries: [FeedEntry]());
        self.collectionViewDelegate = EntryCollectionViewDelegate(callback: self);
        self.dataSource = collectionViewDataSource;
        self.delegate = collectionViewDelegate;
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 1
        flowLayout.minimumInteritemSpacing = 0
        self.collectionViewLayout = flowLayout;
        
        setupRefreshControl();
        
        let nib = UINib(nibName: "EntryCollectionViewCell", bundle: Bundle.main);
        self.register(nib, forCellWithReuseIdentifier: EntryCollectionViewDataSource.CELL_REUSE_ID);
    }
    
    func setupRefreshControl(){
        self.refreshControl = UIRefreshControl(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 60));
        self.refreshControl?.backgroundColor = self.controller?.view.backgroundColor
        self.refreshControl?.tintColor = .white
        self.refreshControl?.attributedTitle = NSAttributedString(string: "Reloading...")
        self.refreshControl?.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged);
    }
    
    @objc func handleRefreshControl(){
        self.controller?.refreshViewController();
    }
    
    func itemClicked(feedEntry: FeedEntry) {
        let vc = EntryDetailsViewController(nibName: "EntryDetailsViewController", bundle: Bundle.main)
        vc.loadItem(item: feedEntry)
        self.controller?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func reloadEntries(entries:[FeedEntry]?){
        guard let entries = entries else{
            return;
        }
        
        self.collectionViewDataSource?.reloadEntries(entries: entries);
        self.reloadData();
        if (self.refreshControl!.isRefreshing){
            self.refreshControl?.endRefreshing();
        }
    }
    
}
