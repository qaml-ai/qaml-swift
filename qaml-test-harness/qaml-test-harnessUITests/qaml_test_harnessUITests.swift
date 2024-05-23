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
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        let app = XCUIApplication()
        app.launch()

        let q = QamlClient(apiKey: ProcessInfo.processInfo.environment["QAML_API_KEY"]!, app: app)
        q.switchToApp(bundleId: "com.apple.Music")
        q.execute("tap something. doesn't matter what")
    }

}
