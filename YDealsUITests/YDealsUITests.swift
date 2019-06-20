//
//  YDealsUITests.swift
//  YDealsUITests
//
//  Created by Ehssan on 2019-04-09.
//  Copyright © 2019 SolidXpert. All rights reserved.
//

import XCTest

class YDealsUITests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.


        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
//        let app = XCUIApplication()
//        setupSnapshot(app)
//        app.launch()
//
//        snapshot("PrivacyPolicy")
//        app.buttons["I Agree"].tap()
//
//        snapshot("Notifications")
//        app.buttons["Yes, Please"].tap()
//
//        snapshot("AirportPicker")
//        app.alerts["Allow “YDeals” to access your location while you are using the app?"].buttons["Don’t Allow"].tap()
//
////        app.collectionViews.children(matching: .cell).element(boundBy: 0).children(matching: .other).element.tap()
////
////        let ydealsEntrydetailsviewNavigationBar = app.navigationBars["YDeals.EntryDetailsView"]
////        ydealsEntrydetailsviewNavigationBar.buttons["Share"].tap()
////        app.buttons["Cancel"].tap()
////        ydealsEntrydetailsviewNavigationBar.buttons["Back"].tap()
////        app.buttons["settings icon"].tap()
////        app.navigationBars["Settings"].buttons["Back"].tap()
////

    }
    
    
    func testTakeScreenshots() {
        
        
        let app = XCUIApplication()
        app.launchArguments = ["UI_TEST_MODE"]
        setupSnapshot(app)
        app.launch()
        

        
        snapshot("01PrivacyPolicy")
        app.buttons["I Agree"].tap()
        
        snapshot("02Notification")
        app.buttons["Yes, Please"].tap()
        

        addUIInterruptionMonitor(withDescription: "System Dialog") {
            (alert) -> Bool in
            alert.buttons["Don’t Allow"].tap()
            return true
        }
        app.tap()
        
//        let alert = app.alerts["Allow “YDeals” to access your location while you are using the app?"]
//        let _ = alert.waitForExistence(timeout: 2)
//        alert.buttons["Don’t Allow"].tap()
        snapshot("03Location")
        
        let yvrpin=app.otherElements.matching(identifier: "YVR").element(boundBy: 0)
        yvrpin.tap();
        
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
