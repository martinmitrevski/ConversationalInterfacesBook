//
//  UITests.swift
//  UITests
//
//  Created by Martin Mitrevski on 27.09.17.
//  Copyright © 2017 Martin Mitrevski. All rights reserved.
//

import XCTest
import ListsSiriKit

class SiriUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false
        XCUIApplication().launch()
    }
    
    private func siri(withExpression expression: String) -> XCUISiriService {
        let siri = XCUIDevice.shared.siriService
        siri.activate(voiceRecognitionText: expression)
        return siri
    }
    
    private func waitForResponse(fromSiri siri: XCUISiriService) {
        let predicate = NSPredicate { (_, _) -> Bool in
            sleep(5)
            return true
        }
        let siriResponseExpectation = expectation(for: predicate,
                                                  evaluatedWith: siri,
                                                  handler: nil)
        self.wait(for: [siriResponseExpectation], timeout: 10)
    }
    
    private func launchApp() -> XCUIApplication {
        let app = XCUIApplication()
        app.launch()
        return app
    }
    
    private func queryForItem(withName name: String,
                              inApp app: XCUIApplication) -> XCUIElementQuery {
        let lists = app.tables.cells.staticTexts
        let query = lists.containing(.staticText, identifier: name)
        return query
    }
    
    private func clear(items: [String], listName: String) {
        for item in items {
            // Mark expression (will remove item from list)
            let expression = "Mark \(item) as completed in \(listName) list in ListsSiriKit"
            
            // Activate Siri for marking
            let markSiri = self.siri(withExpression: expression)
            
            // Wait for Siri response
            waitForResponse(fromSiri: markSiri)
        }
    }
    
    private func testIfExists(item: String, inApp app: XCUIApplication) {
        let query = self.queryForItem(withName: item, inApp: app)
        XCTAssertTrue(query.count >= 1, "\(item) should exist")
    }
    
    func testCreatingList() {
        // Given
        let listName = "grocery"
        
        // Activate Siri
        let siri = self.siri(withExpression: "Create \(listName) list in ListsSiriKit")
        
        // Wait for Siri response
        waitForResponse(fromSiri: siri)
        
        // Launch the app
        let app = launchApp()
        
        // Check if grocery list exists
        testIfExists(item: listName, inApp: app)
    }
    
    func testAddingItems() {
        // Given
        let listName = "grocery"
        let products = [ "Milk", "Sugar" ]
        let productsPhrase = products.joined(separator: " and ")
        let expression = "Add \(productsPhrase) in my \(listName) list in ListsSiriKit"
        
        // Activate Siri
        let siri = self.siri(withExpression: expression)
        
        // Wait for Siri response
        waitForResponse(fromSiri: siri)
        
        // Launch the app
        let app = launchApp()
        
        // Select the grocery list
        let query = self.queryForItem(withName: listName, inApp: app)
        query.element.tap()
        
        // Check if milk exists
        testIfExists(item: products[0], inApp: app)
        
        // Check if sugar exists
        testIfExists(item: products[1], inApp: app)
        
        // Clear added items with the test
        self.clear(items: products, listName: listName)
    }
    
}
