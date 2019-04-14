//
//  File.swift
//  YDeals
//
//  Created by Ehssan on 2019-04-13.
//  Copyright © 2019 SolidXpert. All rights reserved.
//

import Foundation
import UIKit


protocol EntryCollectionViewDelegateCallback : NSObject {
    func itemClicked(feedEntry: FeedEntry);
}

class EntryCollectionViewDelegate: NSObject, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
 
    private weak var callback : EntryCollectionViewDelegateCallback?
    
    init(callback:EntryCollectionViewDelegateCallback) {
        self.callback = callback;
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! EntryCollectionViewCell;
        if let entry = cell.data {
            self.callback?.itemClicked(feedEntry: entry);
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let size = CGSize(width: collectionView.frame.size.width, height: 250);
        return size;
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0);
    }
    

}
