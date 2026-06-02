//
//  URL_OrganizerTests.swift
//  URL OrganizerTests
//
//  Created by Godsfavour Ngo Kio on 2026-06-02.
//

import XCTest
@testable import URL_Organizer

@MainActor
final class URL_OrganizerTests: XCTestCase {
    
    // MARK: - Properties
    var urlViewModel: URLViewModel!

    override func setUpWithError() throws {
        super.setUp()
        urlViewModel = URLViewModel()
    }

    override func tearDownWithError() throws {
        urlViewModel = nil
        super.tearDown()
    }
    
    // MARK: - validateURL
    func test_validateURL_withValidHTTPSURL_returnsTrue(){
        // Arrange
        urlViewModel.currentURL = "https://mozilla.org"
        XCTAssertTrue(urlViewModel.validateURL())
    }
    
    func test_validateURL_withValidHTTPURL_returnsTrue() {
        urlViewModel.currentURL = "http://mozilla.org"
        XCTAssertTrue(urlViewModel.validateURL())
    }
    
    func test_validateURL_withEmptyString_returnsFalse() {
        urlViewModel.currentURL = ""
        XCTAssertFalse(urlViewModel.validateURL())
    }
    
    func test_validateURL_withNoScheme_returnsFalse() {
        urlViewModel.currentURL = "godsfavourkio.com"
        XCTAssertFalse(urlViewModel.validateURL())
    }
    
    func test_validateURL_withSingleLetter_returnsFalse() {
        urlViewModel.currentURL = "g"
        XCTAssertFalse(urlViewModel.validateURL())
    }
    
    func test_validateURL_withValidAllCapsURL_returnsTrue() {
        urlViewModel.currentURL = "HTTPS://MOZILLA.ORG"
        XCTAssertTrue(urlViewModel.validateURL())
    }
    
    func test_validateURL_withInvalidScheme_returnsFalse() {
        urlViewModel.currentURL = "kio://mozilla.org"
        XCTAssertFalse(urlViewModel.validateURL())
    }
    
    func test_validateURL_withInvalidURL_setsErrorMessage() {
        urlViewModel.currentURL = "not a url"
        let _ = urlViewModel.validateURL()
        XCTAssertFalse(urlViewModel.validationErrorMessage.isEmpty)
    }
    
    func test_validateURL_withValidURL_clearsErrorMessage() {
        urlViewModel.validationErrorMessage = "some previous error"
        urlViewModel.currentURL = "https://mozilla.org"
        let _ = urlViewModel.validateURL()
        XCTAssertTrue(urlViewModel.validationErrorMessage.isEmpty)
    }
    
    // MARK: - addURL
    func test_addURL_withValidURL_appendsToList() {
        urlViewModel.currentURL = "https://mozilla.org"
        urlViewModel.addURL()
        XCTAssertEqual(urlViewModel.urlList.count, 1)
    }
    
    func test_addURL_withValidURL_clearsCurrentURL() {
        urlViewModel.currentURL = "https://mozilla.org"
        urlViewModel.addURL()
        XCTAssertTrue(urlViewModel.currentURL.isEmpty)
    }
    
    func test_addURL_withEmptyURL_doesNotAppendToList() {
        urlViewModel.currentURL = ""
        urlViewModel.addURL()
        XCTAssertTrue(urlViewModel.urlList.isEmpty)
    }
    
    func test_addURL_withInvalidURL_doesNotAppendToList() {
        urlViewModel.currentURL = "not-a-url"
        urlViewModel.addURL()
        XCTAssertTrue(urlViewModel.urlList.isEmpty)
    }
    
    func test_addURL_multipleTimes_appendsAllToList() {
        urlViewModel.currentURL = "https://mozilla.org"
        urlViewModel.addURL()
        urlViewModel.currentURL = "https://mozilla.org"
        urlViewModel.addURL()
        XCTAssertEqual(urlViewModel.urlList.count, 2)
    }
    
    // MARK: - removeUrlItem
    func test_removeUrlItem_removesCorrectItem() {
        urlViewModel.currentURL = "https://mozilla.org"
        urlViewModel.addURL()
        let item = urlViewModel.urlList[0]
        urlViewModel.removeUrlItem(item)
        XCTAssertTrue(urlViewModel.urlList.isEmpty)
    }
    
    func test_removeUrlItem_onlyRemovesTargetItem() {
        urlViewModel.currentURL = "https://mozilla.org"
        urlViewModel.addURL()
        urlViewModel.currentURL = "https://apple.com"
        urlViewModel.addURL()
        let itemToRemove = urlViewModel.urlList[0]
        urlViewModel.removeUrlItem(itemToRemove)
        XCTAssertEqual(urlViewModel.urlList.count, 1)
        XCTAssertEqual(urlViewModel.urlList[0].urlString, "https://apple.com")
    }
    
    // MARK: - removeAllURLs
    func test_removeAllURLs_clearsEntireList() {
        urlViewModel.currentURL = "https://mozilla.org"
        urlViewModel.addURL()
        urlViewModel.currentURL = "https://apple.com"
        urlViewModel.addURL()
        urlViewModel.removeAllURLs()
        XCTAssertTrue(urlViewModel.urlList.isEmpty)
    }
    
    func test_removeAllURLs_onEmptyList_doesNotCrash() {
        urlViewModel.removeAllURLs()
        XCTAssertTrue(urlViewModel.urlList.isEmpty)
    }
    
    // MARK: - editURL
    func test_editURL_setsSelectedURLItem() {
        urlViewModel.currentURL = "https://mozilla.org"
        urlViewModel.addURL()
        let item = urlViewModel.urlList[0]
        urlViewModel.editURL(item)
        XCTAssertEqual(urlViewModel.selectedURLItem?.id, item.id)
    }
    
    func test_editURL_setsCurrentURLToItemURLString() {
        urlViewModel.currentURL = "https://mozilla.org"
        urlViewModel.addURL()
        let item = urlViewModel.urlList[0]
        urlViewModel.editURL(item)
        XCTAssertEqual(urlViewModel.currentURL, "https://mozilla.org")
    }
    
    // MARK: - saveEdits
    func test_saveEdits_updatesItemInList() {
        urlViewModel.currentURL = "https://mozilla.org"
        urlViewModel.addURL()
        let item = urlViewModel.urlList[0]
        urlViewModel.editURL(item)
        urlViewModel.currentURL = "https://apple.com"
        urlViewModel.saveEdits()
        XCTAssertEqual(urlViewModel.urlList[0].urlString, "https://apple.com")
    }
    
    func test_saveEdits_clearsSelectedURLItem() {
        urlViewModel.currentURL = "https://mozilla.org"
        urlViewModel.addURL()
        let item = urlViewModel.urlList[0]
        urlViewModel.editURL(item)
        urlViewModel.currentURL = "https://apple.com"
        urlViewModel.saveEdits()
        XCTAssertNil(urlViewModel.selectedURLItem)
    }
    
    func test_saveEdits_clearsCurrentURL() {
        urlViewModel.currentURL = "https://mozilla.org"
        urlViewModel.addURL()
        let item = urlViewModel.urlList[0]
        urlViewModel.editURL(item)
        urlViewModel.currentURL = "https://apple.com"
        urlViewModel.saveEdits()
        XCTAssertTrue(urlViewModel.currentURL.isEmpty)
    }

}
