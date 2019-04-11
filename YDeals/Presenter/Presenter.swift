//
//  Presenter.swift
//  YDeals
//
//  Created by Ehssan on 2019-04-10.
//  Copyright © 2019 SolidXpert. All rights reserved.
//

import Foundation

protocol PresenterDelegate{
    func presenterReadyToPresent<X>(item:X?, error:Error?)
}


protocol Presenter {
    associatedtype T
    func present<T>(item:T)
}
