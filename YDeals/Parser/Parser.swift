//
//  Parser.swift
//  YDeals
//
//  Created by Ehssan on 2019-04-09.
//  Copyright © 2019 SolidXpert. All rights reserved.
//

import Foundation

protocol Parser {
    func parse<T>(url: URL,
                whenFinished:@escaping(_ result:T?, _ error:Error?) -> Void)
}
