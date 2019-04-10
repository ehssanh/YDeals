//
//  Feed.swift
//  YDeals
//
//  Created by Ehssan Hoorvash
//  Copyright © 2019 SolidXpert Software Services and Consulting Inc.
//  All rights reserved.

import Foundation

class Feed{
    var nextFeedLink : String?
    var lastFeedLink : String?
    var entries : Array<FeedEntry>?
    
    init() {
        self.entries = Array<FeedEntry>();
    }
}
