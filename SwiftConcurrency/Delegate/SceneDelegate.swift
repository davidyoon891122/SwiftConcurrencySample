//
//  SceneDelegate.swift
//  SwiftConcurrency
//
//  Created by Davidyoon on 8/13/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        
        let mainNavigationController = UINavigationController()
        
        
        let mainNavigator = MainNavigator(navigationController: mainNavigationController)
        mainNavigator.toMain()
        
        window?.rootViewController = mainNavigationController
        window?.makeKeyAndVisible()
    }

}

