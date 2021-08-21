//
//  ToDosCategoryUITests.swift
//  ToDosCategoryUITests
//
//  Created by Iurii Chernovalov on 08.06.21.
//

import XCTest

class ToDosCategoryUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        
    }

    func testAddCategory() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        app.navigationBars.buttons["Add"].tap()
        app.alerts.textFields["Create new Category"].tap()
        app.alerts.textFields["Create new Category"].typeText("AddCategory")
        app.alerts.scrollViews.otherElements.buttons["Ok"].tap()
        
        XCTAssert(app.cells.staticTexts["AddCategory"].exists)
        
    }
    func testEditCategory() throws {
        let app = XCUIApplication()
        app.launch()
        app.navigationBars.buttons["Add"].tap()
        app.alerts.textFields["Create new Category"].tap()
        app.alerts.textFields["Create new Category"].typeText("EditCategory")
        app.alerts.scrollViews.otherElements.buttons["Ok"].tap()
        app.launch()
        app.cells.staticTexts["EditCategory"].swipeLeft()
        app.buttons["Edit"].tap()
        app.alerts.textFields["Edit current Category"].tap()
        app.alerts.textFields["Edit current Category"].typeText("2")
        app.alerts.scrollViews.otherElements.buttons["Ok"].tap()
        XCTAssert(app.cells.staticTexts["EditCategory2"].exists)
    }
    func testDeleteCategoryButton() throws {
        let app = XCUIApplication()
        app.launch()
        app.navigationBars.buttons["Add"].tap()
        app.alerts.textFields["Create new Category"].tap()
        app.alerts.textFields["Create new Category"].typeText("TestDeleteButton")
        app.alerts.scrollViews.otherElements.buttons["Ok"].tap()
        app.cells.staticTexts["TestDeleteButton"].swipeLeft()
        app.buttons["Delete"].tap()
        XCTAssertFalse(app.cells.staticTexts["TestDeleteButton"].exists)
    }
    func testDeleteCategorySwipe() throws {
        let app = XCUIApplication()
        app.launch()
        app.navigationBars.buttons["Add"].tap()
        app.alerts.textFields["Create new Category"].tap()
        app.alerts.textFields["Create new Category"].typeText("TestDeleteSwipe")
        app.alerts.scrollViews.otherElements.buttons["Ok"].tap()
        app.cells.staticTexts["TestDeleteSwipe"].swipeLeft()
        app.cells.staticTexts["TestDeleteSwipe"].swipeLeft()
        XCTAssertFalse(app.cells.staticTexts["TestDeleteSwipe"].exists)
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
