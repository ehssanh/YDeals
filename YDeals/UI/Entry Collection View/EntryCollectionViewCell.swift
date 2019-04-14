//
//  EntryCollectionViewCell.swift
//  YDeals
//
//  Created by Ehssan on 2019-04-13.
//  Copyright © 2019 SolidXpert. All rights reserved.
//

import UIKit

class EntryCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var title: UILabel!
    
    var data : FeedEntry?
    
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.backgroundColor = .red
    }
    
    func loadData(entry: FeedEntry) -> Void {
        
        self.data = entry;
        
        self.title.text = entry.title;
        self.title.sizeToFit();
    
        self.backgroundImage.lazyLoadFromUrl(url: entry.imageUrl!);
    }

}
