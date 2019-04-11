//
//  ViewController.swift
//  YDeals
//
//  Created by Ehssan on 2019-04-09.
//  Copyright © 2019 SolidXpert. All rights reserved.
//

import UIKit

class ViewController: UIViewController, PresenterDelegate {

    //private var dataProvider : DataProvider<Feed>
    private var parser : GenericFeedParser!
    private var presenter : FeedPresenter!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        let feedUrl = URL(string: "https://www.yvrdeals.com/atom/1");
        self.parser = FeedkitParser(feedUrl: feedUrl!);
        self.presenter = FeedPresenter(parser:self.parser, delegate: self);
        
    }

    func presenterReadyToPresent<Feed>(item: Feed?, error: Error?) {
        if let err = error {
            //TODO : Show a meaningful Error
            print(err.localizedDescription);
            return;
        }
        
        //Feed ready to be presented.
    }

}

