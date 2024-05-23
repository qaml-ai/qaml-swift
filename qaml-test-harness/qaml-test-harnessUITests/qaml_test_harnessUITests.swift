//
//  qaml_test_harnessUITests.swift
//  qaml-test-harnessUITests
//
//  Created by Miguel Salinas on 5/23/24.
//

import XCTest
import qaml

final class qaml_test_harnessUITests: XCTestCase {

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

        let q = QamlClient(apiKey: ProcessInfo.processInfo.environment["QAML_API_KEY"]!, app: app)
        q.switchToApp(bundleId: "com.apple.Music")
        q.execute("tap something. doesn't matter what")
    }

}
