//
//  qaml_sanity_tests.swift
//  qaml-test-harnessUITests
//  End to end tests for qaml
//  Created by Illiana Reed on 5/24/24.
//

import XCTest
import qaml

final class qaml_sanity_tests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_sanityOne_execute() throws {
        // Set the bundle ID of the app you'd like to test
        let app = XCUIApplication(bundleIdentifier: "com.apple.weather")
        app.launch()
        
        let q = QamlClient(
            apiKey: ProcessInfo.processInfo.environment["QAML_API_KEY"]!,
            app: app
        )
        
        q.execute("click the location list button")
        q.execute("tap the search bar at the top")
        q.execute("type San Francisco")
        q.execute("tap San Francisco, CA United States")
        q.assertCondition("The screen shows the weather for San Francisco")
    }
    
    func test_sanityTwo_assert() throws {
        // Set the bundle ID of the app you'd like to test
        let app = XCUIApplication(bundleIdentifier: "com.google.ios.youtube")
        app.launch()
        
        let q = QamlClient(
            apiKey: ProcessInfo.processInfo.environment["QAML_API_KEY"]!,
            app: app
        )
        
        q.waitUntil("the app has succesfully loaded")
        q.assertCondition("the screen shows an app. There is a navigation bar at the bottom with 5 tabs including 'Home', 'Shorts', 'Subscriptions' and 'You'")
        q.execute("tap the 'Shorts' tab")
        q.assertCondition("The screenshot is of YouTube Shorts. It shows a video or image. The bottom section of the screen shows the video's title, the creator's username. On the right there are options to like, dislike, comment, and share.")
        q.execute("tap the view comments button")
        q.assertCondition("The screen shows an app with a drawer of comments open that takes up most of the screen")
        q.execute("tap the view replies button")
        q.assertCondition("The screen shows an app with a drawer labeled Replies open that takes up most of the screen")
        q.execute("tap the close button")
        q.assertCondition("The screenshot is of YouTube Shorts. It shows a video or image. The bottom section of the screen shows the video's title, the creator's username. On the right there are options to like, dislike, comment, and share.")
        q.execute("tap the search button")
        q.assertCondition("The screen shows the search page of YouTube. There is a searchbar at the top.")
        q.execute("tap the back button")
        q.assertCondition("The screenshot is of YouTube Shorts. It shows a video or image. The bottom section of the screen shows the video's title, the creator's username. On the right there are options to like, dislike, comment, and share.")
    }

}
