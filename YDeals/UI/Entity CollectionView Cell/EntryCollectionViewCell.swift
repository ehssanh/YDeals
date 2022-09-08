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
        
    }
    
    func loadData(entry: FeedEntry) -> Void {
        
        self.data = entry;
        
        self.title.text = entry.title;
        self.title.frame = CGRect(x: 8, y: 10, width: self.contentView.frame.size.width-10 , height: self.frame.size.height / 2.0);
        self.title.sizeToFit();
    
        if let imageUrl = entry.imageUrl {
            self.backgroundImage.lazyLoadFromUrl(url: imageUrl)
        }
    }

}
