//
//  SceneDelegate.swift
//  qaml-test-harness
//
//  Created by Miguel Salinas on 5/23/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        let initialViewController = ViewController()
        window?.rootViewController = initialViewController
        window?.makeKeyAndVisible()
    }
}

