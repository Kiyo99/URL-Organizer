//
//  URL_OrganizerUITests.swift
//  URL OrganizerUITests
//
//  Created by Godsfavour Ngo Kio on 2026-06-02.
//

import XCTest

final class URL_OrganizerUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    override func tearDownWithError() throws {
        app = nil
    }
    
    // MARK: - Add URL
    
    func test_addURL_buttonExistsOnLaunch() {
        XCTAssertTrue(app.buttons["Add URL"].exists)
    }
    
    func test_addURL_withValidURL_appearsInList() {
        addURL("https://mozilla.org")
        XCTAssertTrue(app.buttons["https://mozilla.org"].waitForExistence(timeout: 2))
    }
    
    func test_addURL_withInvalidURL_showsAlert() {
        app.textFields["Enter a url here..."].tap()
        app.textFields["Enter a url here..."].typeText("notaurl")
        app.buttons["Add URL"].tap()
        XCTAssertTrue(app.alerts.firstMatch.waitForExistence(timeout: 2))
    }
    
    func test_addURL_withEmptyField_doesNotAddToList() {
        app.buttons["Add URL"].tap()
        XCTAssertEqual(app.cells.count, 0)
    }
    
    func test_addURL_multipleURLs_allAppearInList() {
        addURL("https://mozilla.org")
        addURL("https://apple.com")
        XCTAssertTrue(app.buttons["https://mozilla.org"].exists)
        XCTAssertTrue(app.buttons["https://apple.com"].exists)
    }
    
    // MARK: - Long Press Actions
    
    func test_longPress_showsConfirmationDialog() {
        addURL("https://mozilla.org")
        app.buttons["https://mozilla.org"].press(forDuration: 1)
        XCTAssertTrue(app.buttons["Edit"].waitForExistence(timeout: 2))
    }
    
    func test_longPress_edit_changesButtonToSaveEdit() {
        addURL("https://mozilla.org")
        app.buttons["https://mozilla.org"].press(forDuration: 1)
        app.buttons["Edit"].tap()
        XCTAssertTrue(app.buttons["Save Edit"].waitForExistence(timeout: 2))
    }
    
    func test_longPress_remove_removesItemFromList() {
        addURL("https://mozilla.org")
        app.buttons["https://mozilla.org"].press(forDuration: 1)
        app.buttons["Remove"].tap()
        XCTAssertFalse(app.staticTexts["https://mozilla.org"].waitForExistence(timeout: 2))
    }
    
    func test_longPress_removeAll_clearsEntireList() {
        addURL("https://mozilla.org")
        addURL("https://apple.com")
        app.buttons["https://mozilla.org"].press(forDuration: 1)
        app.buttons["Remove All"].tap()
        XCTAssertFalse(app.staticTexts["https://mozilla.org"].exists)
        XCTAssertFalse(app.staticTexts["https://apple.com"].exists)
    }
    
    // MARK: - Tap URL
    
    func test_tapURL_opensWebView() {
        addURL("https://mozilla.org")
        app.buttons["https://mozilla.org"].tap()
        XCTAssertTrue(app.webViews.firstMatch.waitForExistence(timeout: 5))
    }
    
    // MARK: - Helpers
    
    private func addURL(_ url: String) {
        let textField = app.textFields["Enter a url here..."]
        textField.tap()
        textField.typeText(url)
        app.buttons["Add URL"].tap()
    }
}
