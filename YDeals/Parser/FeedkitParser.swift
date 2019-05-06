//
//  FeedkitParser.swift
//  YDeals
//
//  Created by Ehssan on 2019-04-09.
//  Copyright © 2019 SolidXpert. All rights reserved.
//

import Foundation

class FeedkitParser: GenericFeedParser {
    
    private var feedUrl : URL
    private let parserError = NSError(domain: "Parser", code: 1, userInfo: nil);
    
    required init(feedUrl: URL) {
        self.feedUrl = feedUrl;
    }

    func updateUrl(feedUrl: URL) {
        self.feedUrl = feedUrl;
    }
    
    func parse(whenFinished onParseFinished:@escaping(_ result:Feed?, _ error:Error?) -> Void) {
        let parser = FeedParser(URL: self.feedUrl);
        
        parser.parseAsync { [weak self] (result) in
            
            guard let feed = result.atomFeed, result.isSuccess else{
                onParseFinished(nil, self?.parserError);
                return;
            }
            
            let result = Feed()
            
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
                
                entryItem.keywords = entry.categories?.map({ (category) -> String in
                    return category.attributes?.term ?? "";
                });
                
                entryItem.link = entry.links?.first(where: { (theLink) -> Bool in
                    return theLink.attributes?.rel=="alternate";
                })?.attributes?.href;
                
                entryItem.title = entry.title;
                
                entryItem.htmlContent = entry.content?.value;
                
                //img src=&quot;https://yvrdeals.com/img/ul/f1rqi551jcrz75do.jpg&quot;
                //<img src=\"https://yvrdeals.com/img/ul/vvnzmb1ubuaswlr0.jpg\"
                if let htmlContent = entryItem.htmlContent {
                    let imgTagRange = htmlContent.range(of: "<img src=\"")!
                    let restOfString = String(htmlContent[imgTagRange.upperBound...]);
                    let indexOfClosingQuote = restOfString.firstIndex(of: "\"");
                    var imgLink = restOfString[...indexOfClosingQuote!];
                    imgLink.removeLast()

                    entryItem.imageUrl = String(imgLink);
                    
                    // Remove the image from the content
                    let closeTagRange = htmlContent.range(of: "<br clear=\"all\"></p>")
                    
                    var newHtmlContent:String
                    if (closeTagRange != nil){
                        newHtmlContent = "<p>" + String(htmlContent[(closeTagRange?.upperBound)!...]);
                        entryItem.htmlContent = newHtmlContent;
                    }else{
                        newHtmlContent = htmlContent
                    }
                    
                    // Remove end tags "Join us .."
                    let rangeOfFooter = newHtmlContent.range(of: "<h3>Join");
                    if let footerRange = rangeOfFooter{
                        newHtmlContent = String(newHtmlContent[...footerRange.lowerBound.advanced(by: -1)])
                        entryItem.htmlContent = newHtmlContent;
                    }
                }
                
                result.entries?.append(entryItem);
            }
            
            onParseFinished(result, nil);
        }
    }
}
