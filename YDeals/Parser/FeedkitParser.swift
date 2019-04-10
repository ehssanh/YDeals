//
//  FeedkitParser.swift
//  YDeals
//
//  Created by Ehssan on 2019-04-09.
//  Copyright © 2019 SolidXpert. All rights reserved.
//

import Foundation
//import FeedKit

class FeedkitParser: Parser {
    private let parserError = NSError(domain: "Parser", code: 1, userInfo: nil);

    func parse<T>(url: URL,whenFinished onParseFinished: @escaping (T?, Error?) -> Void) {
        let parser = FeedParser(URL: url);
        
        parser.parseAsync { [weak self] (result) in
            
            guard let feed = result.atomFeed, result.isSuccess else{
                onParseFinished(nil, self?.parserError);
                return;
            }
            
            let result = Feed.init();
            
            guard let entries = feed.entries else {
                onParseFinished(nil, self?.parserError);
                return;
            }
            
            if let links = feed.links  {
                for link in links{
                    if (link.attributes?.rel=="next"){
                        result.nextFeedLink = link.attributes?.href;
                    }else if (link.attributes?.rel=="last"){
                        result.lastFeedLink = link.attributes?.href;
                    }
                }
            }
            
            for entry in entries {
                let entryItem = FeedEntry();
                
                entryItem.id = entry.id;
                entryItem.htmlContent = entry.content?.value;
                
                entryItem.keywords = entry.categories?.map({ (category) -> String in
                    return category.attributes?.term ?? "";
                });
                
                entryItem.link = entry.links?.first(where: { (theLink) -> Bool in
                    theLink.attributes?.rel=="alternate";
                })?.attributes?.href;
                
                entryItem.title = entry.title;
                result.entries?.append(entryItem);
            }
            
            print(result);
    }
    
    
    
    func parse<T>(url: URL, whenFinished: @escaping (T, Error?) -> Void) where T:Feed {
        
    }


    
}
