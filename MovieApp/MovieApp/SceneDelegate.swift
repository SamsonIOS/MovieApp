// SceneDelegate.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Scene Delegate
final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        let pageVC = UINavigationController(rootViewController: FirstViewController())
        window?.rootViewController = pageVC
        window?.makeKeyAndVisible()
    }
}
