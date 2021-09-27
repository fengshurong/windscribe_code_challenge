//
//  WindscribeChallengeUITests.swift
//  WindscribeChallengeUITests
//
//  Created on 27/09/2021.
//

import XCTest

class WindscribeChallengeUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        let tablesQuery = XCUIApplication().tables
        let usEastStaticText = tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["US East"]/*[[".cells.staticTexts[\"US East\"]",".staticTexts[\"US East\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        usEastStaticText.tap()
        tablesQuery/*@START_MENU_TOKEN@*/.tables.staticTexts["- Boston - MIT - 199.217.104.226"]/*[[".cells.tables",".cells.staticTexts[\"- Boston - MIT - 199.217.104.226\"]",".staticTexts[\"- Boston - MIT - 199.217.104.226\"]",".tables"],[[[-1,3,1],[-1,0,1]],[[-1,2],[-1,1]]],[0,0]]@END_MENU_TOKEN@*/.tap()
        usEastStaticText.tap()
    }
}
