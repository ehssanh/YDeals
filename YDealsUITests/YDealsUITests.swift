//
//  YDealsUITests.swift
//  YDealsUITests
//
//  Created by Ehssan on 2019-04-09.
//  Copyright © 2019 SolidXpert. All rights reserved.
//

import XCTest

class YDealsUITests: XCTestCase {

    var app : XCUIApplication!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = true

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
//        app = XCUIApplication()
//        setupSnapshot(app)
//        app.launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    
    func testTakeScreenshots() {
        
        let app = XCUIApplication()
        app.launchArguments = ["UI_TEST_MODE"]
        setupSnapshot(app)
        app.launch()

        snapshot("01PrivacyPolicy")
        
        app.buttons["I Agree"].waitForExistence(timeout: 2)
        app.buttons["I Agree"].tap()

        snapshot("02Notification")
        app.buttons["Yes, Please"].waitForExistence(timeout: 2)
        app.buttons["Yes, Please"].tap()

        addUIInterruptionMonitor(withDescription: "System Dialog") {
            (alert) -> Bool in
            alert.buttons["Allow"].tap()
            return true
        }
        app.tap()

        let map = app.maps.element(boundBy: 0);
        let _ = map.waitForExistence(timeout: 3)
        
        snapshot("03Location")
        
        let pin = app.otherElements.matching(identifier: "YYZ").element(boundBy: 0)
        let _ = pin.waitForExistence(timeout: 4)
        
        pin.tap();

        snapshot("04List")
        app.collectionViews.children(matching: .cell).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.tap()

        snapshot("05Detail")
        let ydealsEntrydetailsviewNavigationBar = app.navigationBars["YDeals.EntryDetailsView"]

        snapshot("06Share")
        ydealsEntrydetailsviewNavigationBar.buttons["Share"].tap()
        app.buttons["Cancel"].tap()
        ydealsEntrydetailsviewNavigationBar.buttons["Back"].tap()
        app.buttons["settings icon"].tap()

        snapshot("06Settings")
        app.tables/*@START_MENU_TOKEN@*/.staticTexts["Change Airport"]/*[[".cells.staticTexts[\"Change Airport\"]",".staticTexts[\"Change Airport\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.alerts["Error"].buttons["Ok"].tap()
        
    }

}
