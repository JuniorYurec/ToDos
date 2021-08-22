//
//  ToDosItemsUITests.swift
//  ToDosUITests
//
//  Created by Iurii Chernovalov on 21.08.21.
//

import XCTest

class ToDosItemsUITests: XCTestCase {

    override func setUpWithError() throws {

        continueAfterFailure = false

        XCUIApplication().launch()

    }

    override func tearDownWithError() throws {

    }

    func testAddToDo() throws {
        let app = XCUIApplication()
        app.launch()
        app.navigationBars.buttons["Add"].tap()
        app.alerts.textFields["Create new Category"].tap()
        app.alerts.textFields["Create new Category"].typeText("AddCategory")
        app.alerts.scrollViews.otherElements.buttons["Ok"].tap()
        app.launch()
        app.tables.element(boundBy: 0).cells.element(boundBy: 0).tap()
        app.navigationBars.buttons["Add"].tap()
        app.alerts.textFields["Create new ToDo"].tap()
        app.alerts.textFields["Create new ToDo"].typeText("AddToDo")
        app.alerts.scrollViews.otherElements.buttons["Ok"].tap()
        
        XCTAssert(app.cells.staticTexts["AddToDo"].exists)
        
    }
    func testEditToDo() throws {
        let app = XCUIApplication()
        app.launch()
        app.navigationBars.buttons["Add"].tap()
        app.alerts.textFields["Create new Category"].tap()
        app.alerts.textFields["Create new Category"].typeText("CategoryForEditTodo")
        app.alerts.scrollViews.otherElements.buttons["Ok"].tap()
        app.launch()
        app.cells.staticTexts["CategoryForEditTodo"].tap()
        app.navigationBars.buttons["Add"].tap()
        app.alerts.textFields["Create new ToDo"].tap()
        app.alerts.textFields["Create new ToDo"].typeText("EditToDo")
        app.alerts.scrollViews.otherElements.buttons["Ok"].tap()
        app.launch()
        app.cells.staticTexts["CategoryForEditTodo"].tap()
        app.cells.staticTexts["EditToDo"].swipeLeft()
        app.buttons["Edit"].tap()
        app.alerts.textFields["Edit current ToDo"].tap()
        app.alerts.textFields["Edit current ToDo"].typeText("2")
        app.alerts.scrollViews.otherElements.buttons["Ok"].tap()
        XCTAssert(app.cells.staticTexts["EditToDo2"].exists)
    }
    func testDeleteToDoButton() throws {
        let app = XCUIApplication()
        app.launch()
        app.navigationBars.buttons["Add"].tap()
        app.alerts.textFields["Create new Category"].tap()
        app.alerts.textFields["Create new Category"].typeText("CategoryForDeleteTodo")
        app.alerts.scrollViews.otherElements.buttons["Ok"].tap()
        app.launch()
        app.cells.staticTexts["CategoryForDeleteTodo"].tap()
        app.navigationBars.buttons["Add"].tap()
        app.alerts.textFields["Create new ToDo"].tap()
        app.alerts.textFields["Create new ToDo"].typeText("DeleteToDo")
        app.alerts.scrollViews.otherElements.buttons["Ok"].tap()
        app.launch()
        app.cells.staticTexts["CategoryForDeleteTodo"].tap()
        app.cells.staticTexts["DeleteToDo"].swipeLeft()
        app.buttons["Delete"].tap()
        XCTAssertFalse(app.cells.staticTexts["DeleteToDo"].exists)
    }
    func testDeleteToDoSwipe() throws {
        let app = XCUIApplication()
        app.launch()
        app.navigationBars.buttons["Add"].tap()
        app.alerts.textFields["Create new Category"].tap()
        app.alerts.textFields["Create new Category"].typeText("CategoryForDeletePerSwipeTodo")
        app.alerts.scrollViews.otherElements.buttons["Ok"].tap()
        app.launch()
        app.cells.staticTexts["CategoryForDeletePerSwipeTodo"].tap()
        app.navigationBars.buttons["Add"].tap()
        app.alerts.textFields["Create new ToDo"].tap()
        app.alerts.textFields["Create new ToDo"].typeText("DeleteToDoPerSwipe")
        app.alerts.scrollViews.otherElements.buttons["Ok"].tap()
        app.launch()
        app.cells.staticTexts["CategoryForDeletePerSwipeTodo"].tap()
        app.cells.staticTexts["DeleteToDoPerSwipe"].swipeLeft()
        app.cells.staticTexts["DeleteToDoPerSwipe"].swipeLeft()
        XCTAssertFalse(app.cells.staticTexts["DeleteToDoPerSwipe"].exists)
    }

}
