import XCTest

class LinkShortenerUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments.append("--uitesting")
    }
    
    func testUrlListSwipeUp() throws {
        app.launch()
        
        let recentlyUrlTableView = app.tables["recentlyUrlTableView"]
        
        if recentlyUrlTableView.isSelected {
            XCTAssertTrue(recentlyUrlTableView.exists)
        }
        
        recentlyUrlTableView.swipeUp()
    }
    
    func testUrlCellTap() throws {
        app.launch()
        
        let recentlyUrlTableView = app.tables["recentlyUrlTableView"]
        
        if recentlyUrlTableView.isSelected {
            XCTAssertTrue(recentlyUrlTableView.exists)
        }
        
        let urlCell = recentlyUrlTableView.cells["urlCell"]
        urlCell.firstMatch.tap()
    }
    
    func testTypeInTextFieldAndSend() throws {
        app.launch()
        
        let urlTextField = app.textFields["urlTextField"].firstMatch
        
        if urlTextField.isSelected {
            XCTAssertTrue(urlTextField.exists)
        }
        urlTextField.tap()
        urlTextField.typeText("www.google.com")
        
        let sendButton = app.buttons["sendButton"].firstMatch
        
        if sendButton.isSelected {
            XCTAssertTrue(sendButton.exists)
        }
        sendButton.tap()
    }
}
