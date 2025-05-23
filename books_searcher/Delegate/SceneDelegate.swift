//
//  SceneDelegate.swift
//  books_searcher
//
//  Created by Heawon Seo on 4/28/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
         
        window = UIWindow(windowScene: windowScene)
        window?.overrideUserInterfaceStyle = .light
        
        let searchVC = SearchViewController(viewModel: DIContainer.shared.makeSearchViewModel())
        let searchNaviVC = UINavigationController(rootViewController: searchVC)
        window?.rootViewController = searchNaviVC
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {}

    func sceneDidBecomeActive(_ scene: UIScene) {}

    func sceneWillResignActive(_ scene: UIScene) {}

    func sceneWillEnterForeground(_ scene: UIScene) {}

    func sceneDidEnterBackground(_ scene: UIScene) {}

}

