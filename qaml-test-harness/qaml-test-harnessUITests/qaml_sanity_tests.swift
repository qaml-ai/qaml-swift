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

    func test_weatherApp_weatherInSF() throws {
        let app = XCUIApplication(bundleIdentifier: "com.apple.weather")
        app.launch()
        
        let q = QamlClient(
            apiKey: ProcessInfo.processInfo.environment["QAML_API_KEY"]!,
            app: app
        )
        
        q.execute("click the location list button")
        q.execute("tap the search bar at the top")
        q.execute("type San Francisco")
        q.execute("tap the first result in the location list, 'San Francisco, CA United States'")
        q.assertCondition("The screen shows the weather for San Francisco")
    }
    
    func test_youtube_lotsOfAsserts() throws {
        let app = XCUIApplication(bundleIdentifier: "com.google.ios.youtube")
        app.launch()
        
        let q = QamlClient(
            apiKey: ProcessInfo.processInfo.environment["QAML_API_KEY"]!,
            app: app
        )
        
        q.waitUntil("the app has succesfully loaded")
        q.assertCondition("the screen shows an app. There is a navigation bar at the bottom with 5 tabs including 'Home', 'Shorts', 'Subscriptions' and 'You'")
        q.execute("tap the 'Shorts' tab in the bottom nav bar")
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
    func test_youtube_basicAutoDelay() throws {
        let app = XCUIApplication(bundleIdentifier: "com.google.ios.youtube")
        app.launch()
        
        let q = QamlClient(
            apiKey: ProcessInfo.processInfo.environment["QAML_API_KEY"]!,
            app: app
        )
        
        q.autoDelay = 2
        
        q.waitUntil("the app has succesfully loaded")
        q.execute("tap the 'Shorts' tab")
        
    }
    func test_instgram_likeWithSystemPrompt() throws {
        let app = XCUIApplication(bundleIdentifier: "com.burbn.instagram")
        app.launch()
        
        let q = QamlClient(apiKey: ProcessInfo.processInfo.environment["QAML_API_KEY"]!, app: app)
        
        q.systemPrompt = "An image is like if the heart icon is solid is red. An image is not liked if the heart icon is a white outline and not filled."
        
        q.execute("scroll down")
        q.assertCondition("A photo with a heart button beneath it is visible")
        q.assertCondition("A photo with a heart button beneath it is visible. The photo is not liked.")
        q.execute("tap the like button")
        q.assertCondition("A photo with a heart button beneath it is visible. The photo has been liked.")
    }
    func test_snapchat_shareCameraRoll() throws {
        let app = XCUIApplication(bundleIdentifier: "com.toyopagroup.picaboo")
        app.launch()
        
        let q = QamlClient(apiKey: ProcessInfo.processInfo.environment["QAML_API_KEY"]!, app: app)
        
        
        q.execute("tap the memories button")
        q.execute("tap Camera Roll at the top")
        q.execute("Tap the Enable button")
        q.waitUntil("Settings for Snapchat are visible")
        q.switchToApp(bundleId: "com.apple.Preferences")
        q.assertCondition("User is in the Settings page for Snapchat")
        q.execute("Tap Photos None button")
        q.execute("tap Full Access")
        q.assertCondition("Modal appears asking for full access to photo library")
        q.execute("tap Allow Full Access button")
        q.assertCondition("There is no modal on screen")
        q.switchToApp(bundleId: "com.toyopagroup.picaboo")
        q.execute("tap the memories button")
        q.execute("tap Camera Roll at the top")
        q.assertCondition("A camera roll of photos are showing")
        q.switchToApp(bundleId: "com.apple.Preferences")
        q.assertCondition("User is in the Photo library access page")
        q.execute("tap none")
    }
    
    func test_timerApp_waitUntil() throws {
        let app = XCUIApplication(bundleIdentifier: "com.apple.mobiletimer")
        app.launch()
        
        let q = QamlClient(apiKey: ProcessInfo.processInfo.environment["QAML_API_KEY"]!, app: app)
        
        
        q.execute("tap the stopwatch tab")
        q.execute("tap the start button")
        q.waitUntil("The timer is over 35 seconds", timeout: 40)
        q.execute("Tap the stop button")
        q.execute("Tap the reset button")
        q.assertCondition("the screenshot shows a timer with a zero value and a green start button")
    }
    func test_safariApp_openURL() throws {
        let app = XCUIApplication(bundleIdentifier: "com.apple.mobilesafari")
        app.launch()
        
        let q = QamlClient(apiKey: ProcessInfo.processInfo.environment["QAML_API_KEY"]!, app: app)
        
        
        q.openURL(url: "https://ycombinator.com")
        q.assertCondition("the screenshot shows the web page for ycombinator.com")
        q.openURL(url: "https://camelqa.com")
        q.assertCondition("the screenshot shows the web page for camelqa.com with a banner that says 'put your testing on autopilot'")
        q.openURL(url: "https://im3software.com")
        q.assertCondition("the screenshot shows the web page for im3software.com with a logo that says 'IM3'")
    }
    func test09_podiumApp_tapAndTypeRegression() throws {
        let app = XCUIApplication(bundleIdentifier: "com.ionicframework.ionicapp410897")
        app.launch()
        
        let q = QamlClient(
            apiKey: ProcessInfo.processInfo.environment["QAML_API_KEY"]!,
            app: app
        )
        
        q.waitUntil("an app has completed loading")
        q.execute("click the sign in button")
        q.execute("tap enter email text field")
        q.execute("type illiana@camelqa.com")
        q.assertCondition("The screen shows a sign in page with the email 'illiana@camelqa.com' entered in the text field")
        // tap and type bug is still present
        q.type("mikeys@me.com")
        q.assertCondition("The screen shows a sign in page with the email 'mikeys@me.com' entered in the text field")
    }
    func test10_podiumApp_launchApp() throws {
        let app = XCUIApplication(bundleIdentifier: "com.ionicframework.ionicapp410897")
        app.launch()
        
        let q = QamlClient(
            apiKey: ProcessInfo.processInfo.environment["QAML_API_KEY"]!,
            app: app
        )
        
        q.waitUntil("The screen shows an app with a sign in button")
        q.execute("tap the sign in button")
        q.assertCondition("the screenshot shows a text field that says 'your email or phone number' and theres a button that says 'next'")
        q.launchApp(bundleId: "com.ionicframework.ionicapp410897")
        q.waitUntil("The screen shows an app with a sign in button")
    }
    func test11_multiApp_launchApp() throws {
        let app = XCUIApplication(bundleIdentifier: "com.ionicframework.ionicapp410897")
        app.launch()
        
        let q = QamlClient(
            apiKey: ProcessInfo.processInfo.environment["QAML_API_KEY"]!,
            app: app
        )
        
        q.waitUntil("The screen shows an app with a sign in button")
        q.execute("tap the sign in button")
        q.assertCondition("the screenshot shows a text field that says 'your email or phone number' and theres a button that says 'next'")
        q.launchApp(bundleId: "com.ionicframework.ionicapp410897")
        q.waitUntil("The screen shows an app with a sign in button")
        q.launchApp(bundleId: "com.apple.weather")
        q.waitUntil("The screen shows a weather app")
        q.execute("tap the show map button")
        q.assertCondition("the screenshot shows a map view of a weather app")
        q.execute("tap the done button")
        
    }
    func test12_snapchat_tapSettings_buttonWithoutLabel() throws {
        let app = XCUIApplication(bundleIdentifier: "com.toyopagroup.picaboo")
        app.launch()
        
        let q = QamlClient(apiKey: ProcessInfo.processInfo.environment["QAML_API_KEY"]!, app: app)
        
        q.execute("tap the profile button")
        q.execute("tap the settings button")
        q.assertCondition("You are on the Settings page")
        
    }
    func test13_snapchat_scrollUntil() throws {
        let app = XCUIApplication(bundleIdentifier: "com.toyopagroup.picaboo")
        app.launch()
        
        let q = QamlClient(apiKey: ProcessInfo.processInfo.environment["QAML_API_KEY"]!, app: app)
        
        q.execute("tap the profile button")
        // in Swift, takes an enum. Options are .down, .up, .right, .left - double check the syntax for android
        q.scroll(direction: .down, until: "'Cameos' section is visible")
        q.assertCondition("The screen shows a section labeled 'Cameos'")
    }
    func test14_weatherApp_dumpAccessibility() throws {
        let app = XCUIApplication(bundleIdentifier: "com.apple.weather")
        app.launch()
        
        let q = QamlClient(
            apiKey: ProcessInfo.processInfo.environment["QAML_API_KEY"]!,
            app: app,
            useAccessibilityElements: false
        )
        
        q.assertCondition("The screen shows a weather app")
//         shows up in the console - here is a sample output "qaml.QamlClient.Element(left: 347, top: 469, width: 33, height: 86, type: \"button\", label: \"4\U202fPM, Mostly Clear, 62\U00b0\", value: nil, placeholder: nil)" , check LogCat for the output in Android
        q.dumpAccessibilityElements()
    }
<<<<<<< HEAD
    func test15_snapchat_longPress() throws {
        let app = XCUIApplication(bundleIdentifier: "com.toyopagroup.picaboo")
        app.launch()
        
        let q = QamlClient(apiKey: ProcessInfo.processInfo.environment["QAML_API_KEY"]!, app: app)
        // FIXME: Edit this test so it better tests the long press
        
        q.execute("Long press the Take a Snap button")
        q.execute("tap the caption button")
        q.execute("type 'this is my test video sent at <date/time>' but replace <date/time> with the current date and time")
        q.assertCondition("A post is visible within the Snapchat app with a caption. There is a grey story button at the bottom and a blue 'send to' button at the bottom")
        q.execute("tap save to photo gallery button")
        q.execute("tap Send To button")
        q.execute("tap My Story Friends Only")
        q.execute("tap 'CamelTest Account'")
        q.assertCondition("There is a list of contacts. There is a blue banner that says 'CamelTest Account' with a send icon.")
        q.execute("tap Send at the bottom")
        q.assertCondition("A blue banner at the top says 'sent!'")
    }
    func test16_snapchat_getValueFromElementList() throws {
        let app = XCUIApplication(bundleIdentifier: "com.toyopagroup.picaboo")
        app.launch()
        
        let q = QamlClient(apiKey: ProcessInfo.processInfo.environment["QAML_API_KEY"]!, app: app)
        q.apiBaseURL = "https://qaml-api-server-staging.miguel-85b.workers.dev/v1"
        
        q.execute("tap the profile button")
        let settingsID = q.getValue(searchFor: "ID of settings button", mode: .elementList)
        print("~~~~~~ value read from settingsID: ")
        print(settingsID)
    }
    func test17_weather_getValueFromScreenshot() throws {
        let app = XCUIApplication(bundleIdentifier: "com.apple.weather")
        app.launch()
        
        let q = QamlClient(apiKey: ProcessInfo.processInfo.environment["QAML_API_KEY"]!, app: app)
        q.apiBaseURL = "https://qaml-api-server-staging.miguel-85b.workers.dev/v1"
        // FIXME: Edit this test so it better tests the long press
        
        let weatherdescription = q.getValue(searchFor: "The high tomorrow", mode: .screenShot)
        print("~~~~~~ value read from weatherdescription: ")
        print(weatherdescription)
    }
    
    func test18_interrupt_handler() throws {
=======
    func test15_interrupt_handler() throws {
>>>>>>> 1283f15 (adds count to execute)
        let app = XCUIApplication()
        app.resetAuthorizationStatus(for: .camera)
        app.resetAuthorizationStatus(for: .photos)
        app.resetAuthorizationStatus(for: .location)

        let q = QamlClient(
            apiKey: ProcessInfo.processInfo.environment["QAML_API_KEY"]!,
            app: app,
            useAccessibilityElements: false
        )
        // TODO: Remove this line once we update prod server
        q.apiBaseURL = "https://qaml-api-server-staging.miguel-85b.workers.dev/v1"

        app.launchArguments = ["testingPermissions"] // This makes the app show a bunch of permissions on launch
        app.launch()

        q.execute("tap anything") // This should clear all alerts

        let springboard = XCUIApplication(bundleIdentifier: "com.apple.springboard")
        XCTAssertEqual(springboard.alerts.count, 0)
<<<<<<< HEAD
=======
    }
    func test16_snapchat_longPress() throws {
        let app = XCUIApplication(bundleIdentifier: "com.toyopagroup.picaboo")
        app.launch()
        
        let q = QamlClient(apiKey: ProcessInfo.processInfo.environment["QAML_API_KEY"]!, app: app)
        // FIXME: Edit this test so it better tests the long press
        
        q.execute("Long press the Take a Snap button")
        q.execute("tap the caption button")
        q.execute("type 'this is my test video sent at <date/time>' but replace <date/time> with the current date and time")
        q.execute("press done")
        q.assertCondition("A post is visible within the Snapchat app with a caption. There is a grey story button at the bottom and a blue 'send to' button at the bottom")
        q.execute("tap save to photo gallery button")
        q.execute("tap Send To button")
        q.execute("tap My Story Friends Only")
        q.execute("tap 'CamelTest Account'")
        q.assertCondition("There is a list of contacts. There is a blue banner that says 'CamelTest Account' with a send icon.")
        q.execute("tap Send at the bottom")
        q.assertCondition("A blue banner at the top says 'sent!'")
    }
    func test17_snapchat_getValueFromElementList() throws {
        let app = XCUIApplication(bundleIdentifier: "com.toyopagroup.picaboo")
        app.launch()
        
        let q = QamlClient(apiKey: ProcessInfo.processInfo.environment["QAML_API_KEY"]!, app: app)
        q.apiBaseURL = "https://qaml-api-server-staging.miguel-85b.workers.dev/v1"
        
        q.execute("tap the profile button")
        let settingsID = q.getValue(searchFor: "ID of settings button", mode: .elementList)
        print("~~~~~~ value read from settingsID: ")
        print(settingsID)
    }
    func test18_weather_getValueFromScreenshot() throws {
        let app = XCUIApplication(bundleIdentifier: "com.apple.weather")
        app.launch()
        
        let q = QamlClient(apiKey: ProcessInfo.processInfo.environment["QAML_API_KEY"]!, app: app)
        q.apiBaseURL = "https://qaml-api-server-staging.miguel-85b.workers.dev/v1"
        
        let weatherdescription = q.getValue(searchFor: "The high tomorrow", mode: .screenShot)
        print("~~~~~~ value read from weatherdescription: ")
        print(weatherdescription)
    }
    func test19_notes_multiExecute() throws {
        let app = XCUIApplication(bundleIdentifier: "com.apple.mobilenotes")
        app.launch()
        
        let q = QamlClient(apiKey: ProcessInfo.processInfo.environment["QAML_API_KEY"]!, app: app)
        
        q.execute("tap the new note button")
        q.execute("tap the hand wrtiting button")
        q.execute("swipe down", count: 2)
        
>>>>>>> 1283f15 (adds count to execute)
    }
}
