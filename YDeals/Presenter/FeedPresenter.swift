//
//  FeedPresenter.swift
//  YDeals
//
//  Created by Ehssan on 2019-04-10.
//  Copyright © 2019 SolidXpert. All rights reserved.
//

import Foundation



class FeedPresenter : Presenter {
    typealias T = Feed
    
    private var delegate : FeedPresenterDelegate
    private var parser : GenericFeedParser
    
    init(parser:GenericFeedParser, delegate:FeedPresenterDelegate) {
        self.delegate = delegate;
        self.parser = parser;
    }
    
    func present() {
        DispatchQueue.global().async {
            self.parser.parse { (feed, error) in
                
                DispatchQueue.main.async {
                    self.delegate.presenterReadyToPresent(item: feed, error: error);
                }
            }
        }
    }
    
    
}
