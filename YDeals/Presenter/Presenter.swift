//
//  Presenter.swift
//  YDeals
//
//  Created by Ehssan on 2019-04-10.
//  Copyright © 2019 SolidXpert. All rights reserved.
//

import Foundation


protocol Presenter {
    associatedtype T
    func present()
}


protocol PresenterDelegate{
    func presenterReadyToPresent<X>(item:X?, error:Error?)
}


protocol FeedPresenterDelegate {
    func presenterReadyToPresent(item:Feed?, error:Error?)
}
