//
//  ViewController.swift
//  YDeals
//
//  Created by Ehssan on 2019-04-09.
//  Copyright © 2019 SolidXpert. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //private var dataProvider : DataProvider<Feed>
    private var parser : Parser!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.parser = FeedkitParser();
        let feedUrl = URL(string: "https://www.yvrdeals.com/atom/1");
        parser.parse(url: feedUrl!) { (resultDict : Dictionary<String, Any>?, err: Error?) in
    
            
        }
        
    }


}

