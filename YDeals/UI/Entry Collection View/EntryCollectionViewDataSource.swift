//
//  EntryCollectionViewDataSource.swift
//  YDeals
//
//  Created by Ehssan on 2019-04-13.
//  Copyright © 2019 SolidXpert. All rights reserved.
//

import Foundation
import UIKit

class EntryCollectionViewDataSource: NSObject, UICollectionViewDataSource {

    private var data : Array<FeedEntry>
    static var CELL_REUSE_ID = "EntryCellReuseID"
    
    init(entries:Array<FeedEntry>) {
        self.data = Array.init(entries);
    }
    
    func reloadEntries(entries:[FeedEntry]){
        self.data = Array.init(entries);
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.data.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EntryCollectionViewDataSource.CELL_REUSE_ID, for: indexPath) as! EntryCollectionViewCell
        let entry = data[indexPath.row];
        
        cell.loadData(entry: entry);
        
        return cell;
    }
  
}
