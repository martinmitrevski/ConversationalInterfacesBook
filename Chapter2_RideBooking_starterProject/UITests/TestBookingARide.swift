//
//  TestBookingARide.swift
//  UITests
//
//  Created by Martin Mitrevski on 26.09.17.
//  Copyright © 2017 Martin Mitrevski. All rights reserved.
//

import XCTest

class TestBookingARide: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testBasicRideRequest() {
        // Activate Siri
        let siri = XCUIDevice.shared.siriService
        siri.activate(voiceRecognitionText: "Book me a ride from Paris to London")
        
        // Wait for Siri response
        let predicate = NSPredicate { (_, _) -> Bool in
            sleep(5)
            return true
        }
        let siriResponseExpectation = expectation(for: predicate, evaluatedWith: siri, handler: nil)
        self.wait(for: [siriResponseExpectation], timeout: 10)
        print(siriResponseExpectation.expectationDescription)
    }
    
}
