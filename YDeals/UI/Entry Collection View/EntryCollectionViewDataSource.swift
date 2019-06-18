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
    private var filteredResults : Array<FeedEntry>
    private var isFilteringMode = false;
    static var CELL_REUSE_ID = "EntryCellReuseID"
    
    init(entries:Array<FeedEntry>) {
        self.data = Array.init(entries);
        self.filteredResults = Array.init();
    }
    
    func reloadEntries(entries:[FeedEntry]){
        self.isFilteringMode = false;
        self.data = Array.init(entries);
    }
    
    func addEntries(newEntries:[FeedEntry]){
        self.data.append(contentsOf: newEntries);
    }
    
    func filterEntriesWithKeyword(keyword:String){
        self.isFilteringMode = true;
        let filteredResult = self.data.filter { (feedEntry) -> Bool in
            //feedEntry.keywords?.contains(keyword.lowercased()) ?? false;
            
            let filteredKeywords = feedEntry.keywords?.filter({ (item) -> Bool in
                let stringMatch = item.lowercased().range(of: keyword.lowercased())
                return stringMatch != nil ? true : false
            })
            
            return !(filteredKeywords == nil || filteredKeywords!.isEmpty)
        }
        
        self.filteredResults = Array.init(filteredResult);
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.isFilteringMode {
            return self.filteredResults.count
        }else{
            return self.data.count;
        }
    }
    
    func endFilteringMode() -> Void {
        self.isFilteringMode = false;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EntryCollectionViewDataSource.CELL_REUSE_ID, for: indexPath) as! EntryCollectionViewCell
        
        let dataCollection : Array<FeedEntry>
        if (isFilteringMode){
            dataCollection = self.filteredResults;
        }else{
            dataCollection = self.data;
        }
        
        let entry = dataCollection[indexPath.row]
        cell.loadData(entry: entry);
        
        if (!isFilteringMode && indexPath.row == dataCollection.count-1){
            if (collectionView is InfiniteCollectionView){
                (collectionView as! InfiniteCollectionView).requestExpansion();
            }
        }
        
        return cell;
    }
  
}
