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
    
}
