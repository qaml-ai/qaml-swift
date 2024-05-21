import Foundation
import XCTest
import os.log

public class QamlClient {
    let apiKey: String
    var app: XCUIApplication
    let springboard = XCUIApplication(bundleIdentifier: "com.apple.springboard")
    public var systemPrompt = ""
    public var shouldUseAccessibilityElements: Bool

    var logger = OSLog(subsystem: "com.qaml", category: "QamlClient")

    let apiBaseURL = "https://api.camelqa.com/v1"
    
    public init(apiKey: String, app: XCUIApplication, useAccessibilityElements: Bool = true) {
        self.apiKey = apiKey
        self.app = app
        self.shouldUseAccessibilityElements = useAccessibilityElements
    }

    func sleep(duration: TimeInterval) async throws {
        try await Task.sleep(nanoseconds: UInt64(duration * 1_000_000_000))
    }

    func reportError(reason: String) throws {
        throw QAMLException(reason: reason)
        dumpAccessibilityElements()
    }

        func elementTypeString(_ type: XCUIElement.ElementType) -> String {
        let typeString: String
        switch type {
        case .any:
            typeString = "any"
        case .other:
            typeString = "other"
        case .application:
            typeString = "application"
        case .group:
            typeString = "group"
        case .window:
            typeString = "window"
        case .sheet:
            typeString = "sheet"
        case .drawer:
            typeString = "drawer"
        case .alert:
            typeString = "alert"
        case .dialog:
            typeString = "dialog"
        case .button:
            typeString = "button"
        case .radioButton:
            typeString = "radioButton"
        case .radioGroup:
            typeString = "radioGroup"
        case .checkBox:
            typeString = "checkBox"
        case .disclosureTriangle:
            typeString = "disclosureTriangle"
        case .popUpButton:
            typeString = "popUpButton"
        case .comboBox:
            typeString = "comboBox"
        case .menuButton:
            typeString = "menuButton"
        case .toolbarButton:
            typeString = "toolbarButton"
        case .popover:
            typeString = "popover"
        case .keyboard:
            typeString = "keyboard"
        case .key:
            typeString = "key"
        case .navigationBar:
            typeString = "navigationBar"
        case .tabBar:
            typeString = "tabBar"
        case .tabGroup:
            typeString = "tabGroup"
        case .toolbar:
            typeString = "toolbar"
        case .statusBar:
            typeString = "statusBar"
        case .table:
            typeString = "table"
        case .tableRow:
            typeString = "tableRow"
        case .tableColumn:
            typeString = "tableColumn"
        case .outline:
            typeString = "outline"
        case .outlineRow:
            typeString = "outlineRow"
        case .browser:
            typeString = "browser"
        case .collectionView:
            typeString = "collectionView"
        case .slider:
            typeString = "slider"
        case .pageIndicator:
            typeString = "pageIndicator"
        case .progressIndicator:
            typeString = "progressIndicator"
        case .activityIndicator:
            typeString = "activityIndicator"
        case .segmentedControl:
            typeString = "segmentedControl"
        case .picker:
            typeString = "picker"
        case .pickerWheel:
            typeString = "pickerWheel"
        case .switch:
            typeString = "switch"
        case .toggle:
            typeString = "toggle"
        case .link:
            typeString = "link"
        case .image:
            typeString = "image"
        case .icon:
            typeString = "icon"
        case .searchField:
            typeString = "searchField"
        case .scrollView:
            typeString = "scrollView"
        case .scrollBar:
            typeString = "scrollBar"
        case .staticText:
            typeString = "staticText"
        case .textField:
            typeString = "textField"
        case .secureTextField:
            typeString = "secureTextField"
        case .datePicker:
            typeString = "datePicker"
        case .textView:
            typeString = "textView"
        case .menu:
            typeString = "menu"
        case .menuItem:
            typeString = "menuItem"
        case .menuBar:
            typeString = "menuBar"
        case .menuBarItem:
            typeString = "menuBarItem"
        case .map:
            typeString = "map"
        case .webView:
            typeString = "webView"
        case .incrementArrow:
            typeString = "incrementArrow"
        case .decrementArrow:
            typeString = "decrementArrow"
        case .timeline:
            typeString = "timeline"
        case .ratingIndicator:
            typeString = "ratingIndicator"
        case .valueIndicator:
            typeString = "valueIndicator"
        case .splitGroup:
            typeString = "splitGroup"
        case .splitter:
            typeString = "splitter"
        case .relevanceIndicator:
            typeString = "relevanceIndicator"
        case .colorWell:
            typeString = "colorWell"
        case .helpTag:
            typeString = "helpTag"
        case .matte:
            typeString = "matte"
        case .dockItem:
            typeString = "dockItem"
        case .ruler:
            typeString = "ruler"
        case .rulerMarker:
            typeString = "rulerMarker"
        case .grid:
            typeString = "grid"
        case .levelIndicator:
            typeString = "levelIndicator"
        case .cell:
            typeString = "cell"
        case .layoutArea:
            typeString = "layoutArea"
        case .layoutItem:
            typeString = "layoutItem"
        case .handle:
            typeString = "handle"
        case .stepper:
            typeString = "stepper"
        case .tab:
            typeString = "tab"
        case .touchBar:
            typeString = "touchBar"
        case .statusItem:
            typeString = "statusItem"
        }
        return typeString
    }

    struct Element: Encodable {
        let left: Int
        let top: Int
        let width: Int
        let height: Int
        let type: String
        let label: String
        let value: String?
        let placeholder: String?
    }
    
    public func dumpAccessibilityElements() {
        let elements = try! getAccessibilityElements()
        os_log("Accessibility elements: %@", log: logger, type: .debug, elements)
    }

    func getAccessibilityElements() throws -> [Element] {
        // First check springboard for alerts
        let springboardAlerts = springboard.alerts
        let springboardNavigationbars = springboard.navigationBars
        let snapshot: XCUIElementSnapshot
        if springboardAlerts.count > 0 || springboardNavigationbars.count > 0 {
            snapshot = try springboard.snapshot()
        } else {
            snapshot = try app.snapshot()
        }
        var elements = [snapshot]
        var enabledElements: [XCUIElementSnapshot] = []
        let windowScale = getWindowSize().width/app.frame.width

        while !elements.isEmpty {
            let element = elements.removeLast()

            let elementDict = element.dictionaryRepresentation
            let windowContextID = XCUIElement.AttributeName(rawValue: "windowContextID")
            // If elementDict[windowContextID] is 0, skip it.
            if let windowContextIDValue = elementDict[windowContextID] as? Int, windowContextIDValue == 0 {
                continue
            }

            // Check if the element's absolute frame intersects with the main app snapshot frame and if it is enabled.
            if (!element.label.isEmpty || !element.identifier.isEmpty || element.value != nil || element.elementType == .textField || element.elementType == .secureTextField || element.elementType == .textView) && element.isEnabled && snapshot.frame.intersects(element.frame) && element.elementType != .key {
                enabledElements.append(element)
            }

            // Skip child images of labeled buttons. TODO: Reconsider this
            if element.elementType == .button && !element.label.isEmpty {
                continue
            }

            elements.append(contentsOf: element.children)
        }
        // Sort enabled elements by their y position.
        enabledElements.sort { $0.frame.minY < $1.frame.minY }
        var accessibilityElements: [Element] = []
        for element in enabledElements {
            let accessibilityElement = Element(
                left: Int(element.frame.minX * windowScale),
                top: Int(element.frame.minY * windowScale),
                width: Int(element.frame.width * windowScale),
                height: Int(element.frame.height * windowScale),
                type: elementTypeString(element.elementType),
                label: element.label,
                value: element.value != nil ? String(describing: element.value!) : nil,
                placeholder: element.placeholderValue
            )
            accessibilityElements.append(accessibilityElement)
        }
        return accessibilityElements
    }

    @MainActor
    public func execute(_ command: String) async throws {
        var accessibilityElements = try getAccessibilityElements()
        var isKeyboardShown = false
        accessibilityElements = accessibilityElements.filter { element in
            if element.type == "keyboard" || element.type == "key" {
                isKeyboardShown = true
                return false
            }
            return true
        }
        struct ActionRequest: Encodable {
            struct Size: Encodable {
                let width: Int
                let height: Int
            }
            let action: String
            let screen_size: Size
            let screenshot: String
            let platform: String
            let extra_context: String
            let accessibility_elements: [Element]
            let is_keyboard_shown: Bool
        }

        let windowSize = getWindowSize()
        let payload = ActionRequest(
            action: command,
            screen_size: ActionRequest.Size(width: Int(windowSize.width), height: Int(windowSize.height)),
            screenshot: getScreenshot(),
            platform: "iOS",
            extra_context: systemPrompt,
            accessibility_elements: accessibilityElements,
            is_keyboard_shown: isKeyboardShown
        )

        // Make an async request to the QAML API
        let url = URL(string: "\(apiBaseURL)/execute")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.httpBody = try JSONEncoder().encode(payload)

        let (data, httpResponse) = try await URLSession.shared.data(for: request)

        struct Action: Decodable {
            let name: String
            let arguments: String
        }
        let response = try JSONDecoder().decode([Action].self, from: data)
        // arguments is a json encoded string
        for action in response {
            // Decode the arguments
            let arguments = try JSONSerialization.jsonObject(with: action.arguments.data(using: .utf8)!, options: []) as! [String: Any]
            os_log("Command: %@ - Executing action: %@ with arguments: %@", log: logger, type: .debug, command, action.name, arguments)
            switch action.name {
            case "type_text":
                let text = arguments["text"] as! String
                typeText(text: text)
            case "tap":
                let x = Int(arguments["x"] as! Double)
                let y = Int(arguments["y"] as! Double)
                tap(x: x, y: y)
            case "long_press":
                let x = Int(arguments["x"] as! Double)
                let y = Int(arguments["y"] as! Double)
                app.windows.firstMatch.coordinate(withNormalizedOffset: CGVector(dx: 0, dy: 0)).withOffset(CGVector(dx: x, dy: y)).press(forDuration: 1.5)
            case "swipe":
                let direction = arguments["direction"] as! String
                swipe(direction: direction)
            // FIXME: Scroll on scrollable elements
            case "scroll":
                let direction = arguments["direction"] as! String
                scroll(direction: direction)
            case "drag":
                let startX = arguments["startX"] as! Int
                let startY = arguments["startY"] as! Int
                let endX = arguments["endX"] as! Int
                let endY = arguments["endY"] as! Int
                drag(startX: startX, startY: startY, endX: endX, endY: endY)
            case "sleep":
                let duration = arguments["duration"] as! TimeInterval
                try await sleep(duration: duration)
            case "report_error":
                let reason = arguments["reason"] as! String
                try reportError(reason: reason)
            case "assert":
                XCTAssert(arguments["condition"] as! Bool, arguments["message"] as! String)
            default:
                fatalError("Invalid action: \(action.name)")
            }
        }
    }

    @MainActor
    public func switchToApp(bundleId: String) async throws {
        let newApp = XCUIApplication(bundleIdentifier: bundleId)
        if !newApp.exists {
            throw QAMLException(reason: "App with bundle ID \(bundleId) is not installed")
        }
        newApp.activate()
        app = newApp
        try await Task.sleep(nanoseconds: 1_000_000_000)
    }

    @MainActor
    public func openURL(url: String) async throws {
        XCUIDevice.shared.system.open(URL(string: url)!)
        try await Task.sleep(nanoseconds: 1_000_000_000)
    }

    private func getScreenshot(name: String? = nil) -> String {
        let screenshot = app.screenshot()
        let attachment = XCTAttachment(screenshot: screenshot)
        attachment.lifetime = .keepAlways
        if let name = name {
            attachment.name = name
            XCTContext.runActivity(named: name) { activity in
                activity.add(attachment)
            }
        }
        return screenshot.pngRepresentation.base64EncodedString()
    }

    private func getWindowSize() -> CGRect {
        return app.windows.firstMatch.frame
    }

    @MainActor
    public func assertCondition(_ assertion: String) async throws {
        try await sleep(duration: 0.5)
        struct AssertionRequest: Encodable {
            struct Size: Encodable {
                let width: Double
                let height: Double
            }
            let assertion: String
            let screen_size: Size
            let screenshot: String
            let platform: String
            let extra_context: String
            let accessibility_elements: String
        }
        let screenshotData = getScreenshot(name: "Assertion Screenshot \(assertion)")
        let screenSize = getWindowSize()
        let payload = AssertionRequest(
            assertion: assertion,
            screen_size: AssertionRequest.Size(width: screenSize.width, height: screenSize.height),
            screenshot: screenshotData,
            platform: "iOS",
            extra_context: systemPrompt,
            accessibility_elements: ""
        )

        let url = URL(string: "\(apiBaseURL)/assert")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.httpBody = try JSONEncoder().encode(payload)

        let (data, httpResponse) = try await URLSession.shared.data(for: request)

        struct AssertionResponse: Decodable {
            let name: String
            let arguments: String
        }

        let assertionResponses = try JSONDecoder().decode([AssertionResponse].self, from: data)
        let arguments = try JSONSerialization.jsonObject(with: assertionResponses[0].arguments.data(using: .utf8)!, options: []) as! [String: Any]
        guard let result = arguments["result"] as? Bool else {
            throw QAMLException(reason: "Invalid response from QAML API")
        }
        if (!result) {
            throw QAMLException(reason: "Assertion failed: \(assertion). Reason: \(arguments["reason"])")
        }
    }

    @MainActor
    public func waitUntil(_ condition: String, timeout: TimeInterval = 10) async throws {
        let start = Date()
        try await sleep(duration: 0.5)
        while true {
            if Date().timeIntervalSince(start) > timeout {
                throw QAMLException(reason: "Timeout waiting for condition: \(condition)")
            }
            do {
                try await assertCondition(condition)
                return
            } catch {
                os_log("Condition %@ not met yet. Retrying...", log: logger, type: .debug, condition)
            }
        }
    }
    
    struct QAMLException: Error {
        let reason: String
    }

    @MainActor
    func task(task: String, maxSteps: Int = 10) async throws {
        var progress: [String] = []
        var iterations = 0
        while true {
            if iterations >= maxSteps {
                XCTFail("Task execution took too many steps. Max steps: \(maxSteps)")
            }
            iterations += 1
            try await sleep(duration: 0.5)
            let accessibilityElements = try getAccessibilityElements()
            let payload = ["task": task, "progress": progress, "screenshot": getScreenshot(), "accessibility_elements": accessibilityElements] as [String : Any]
        }
    }

    func tap(x: Int, y: Int) {
        app.windows.firstMatch.coordinate(withNormalizedOffset: CGVector(dx: 0, dy: 0)).withOffset(CGVector(dx: x, dy: y)).tap()
    }

    func drag(startX: Int, startY: Int, endX: Int, endY: Int) {
        app.windows.firstMatch.coordinate(withNormalizedOffset: CGVector(dx: 0, dy: 0)).withOffset(CGVector(dx: startX, dy: startY)).press(forDuration: 0.1, thenDragTo: app.coordinate(withNormalizedOffset: CGVector(dx: 0, dy: 0)).withOffset(CGVector(dx: endX, dy: endY)))
    }

    func swipe(direction: String) {
        switch direction {
        case "up":
            app.windows.firstMatch.swipeUp()
        case "down":
            app.windows.firstMatch.swipeDown()
        case "left":
            app.windows.firstMatch.swipeLeft()
        case "right":
            app.windows.firstMatch.swipeRight()
        default:
            fatalError("Invalid swipe direction: \(direction)")
        }
    }

    func scroll(direction: String) {
        switch direction {
        case "up":
            swipe(direction: "down")
        case "down":
            swipe(direction: "up")
        case "left":
            swipe(direction: "right")
        case "right":
            swipe(direction: "left")
        default:
            fatalError("Invalid scroll direction: \(direction)")
        }
    }

    func typeText(text: String) {
        // Clear key HID events to delete the current text
        performIOHIDEvent(page: 0x07, usage: 0x9C, duration: 0.1, device: XCUIDevice.shared)
        let element = app.descendants(matching: .any).matching(NSPredicate(format: "hasKeyboardFocus == true")).element(boundBy: 0)
        if let value = element.value as? String {
            // Use ASCII control characters to delete the current text using delete and forward delete
            let deleteString = String(repeating: "\u{8}", count: value.count)
            let forwardDeleteString = String(repeating: "\u{7F}", count: value.count)
            element.typeText(deleteString + forwardDeleteString)
        }
        element.typeText(text)
    }

    func createXCDeviceEvent(page: UInt32, usage: UInt32, duration: TimeInterval) -> AnyObject? {
        guard let xcDeviceEventClass: AnyObject.Type = NSClassFromString("XCDeviceEvent") else {
            return nil
        }

        let selector = NSSelectorFromString("deviceEventWithPage:usage:duration:")
        guard let method = class_getClassMethod(xcDeviceEventClass, selector) else {
            return nil
        }

        let imp = method_getImplementation(method)
        typealias DeviceEventFunction = @convention(c) (AnyObject, Selector, UInt32, UInt32, TimeInterval) -> AnyObject
        let function = unsafeBitCast(imp, to: DeviceEventFunction.self)

        return function(xcDeviceEventClass, selector, page, usage, duration)
    }

    func performIOHIDEvent(page: UInt32, usage: UInt32, duration: TimeInterval, device: XCUIDevice) {
        guard let event = createXCDeviceEvent(page: page, usage: usage, duration: duration) else {
            return
        }

        let selector = NSSelectorFromString("performDeviceEvent:error:")
        guard let method = class_getInstanceMethod(XCUIDevice.self, selector) else {
            return
        }

        let imp = method_getImplementation(method)
        typealias PerformDeviceEventFunction = @convention(c) (AnyObject, Selector, AnyObject, UnsafeMutablePointer<NSError?>?) -> Bool
        let function = unsafeBitCast(imp, to: PerformDeviceEventFunction.self)

        var error: NSError?
        let result = function(device, selector, event, &error)

        if let error = error {
            os_log("Error performing device event: %@", log: logger, type: .error, error)
        } else if !result {
            os_log("Failed to perform device event.", log: logger, type: .error)
        }
    }

}


