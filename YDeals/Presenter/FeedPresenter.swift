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
    
    private var delegate : PresenterDelegate
    private var parser : GenericFeedParser
    
    init(parser:GenericFeedParser, delegate:PresenterDelegate) {
        self.delegate = delegate;
        self.parser = parser;
    }
    
    func present<T>(item: T) {
        DispatchQueue.global().async {
            self.parser.parse { (feed, error) in
                DispatchQueue.main.async {
                    self.delegate.presenterReadyToPresent(item: feed, error: error);
                }
            }
        }
    }
    
    
}
