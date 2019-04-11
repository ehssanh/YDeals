//
//  Parser.swift
//  YDeals
//
//  Created by Ehssan on 2019-04-09.
//  Copyright © 2019 SolidXpert. All rights reserved.
//

import Foundation

protocol GenericParser {
    associatedtype T
    func parse<T>(whenFinished:@escaping(_ result:T?, _ error:Error?) -> Void)
}

protocol GenericFeedParser {
    init(feedUrl:URL)
    func parse(whenFinished:@escaping(_ result:Feed?, _ error:Error?) -> Void)
}
