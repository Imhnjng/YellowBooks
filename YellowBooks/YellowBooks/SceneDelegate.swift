//
//  SceneDelegate.swift
//  YellowBooks
//
//  Created by IMHYEONJEONG on 5/3/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        let firstViewController = UINavigationController(rootViewController: MainViewController())
        let SecondViewController = UINavigationController(rootViewController: SearchViewController())
        let ThirdViewController = UINavigationController(rootViewController: LibraryViewController())
        
        let tabBarController = UITabBarController()
        tabBarController.setViewControllers([firstViewController, SecondViewController, ThirdViewController], animated: true)
        
        if let items = tabBarController.tabBar.items {
            items[0].selectedImage = UIImage(systemName: "house")
            items[0].image = UIImage(systemName: "house")
            items[0].title = "Home"
            
            items[1].selectedImage = UIImage(systemName: "doc.text.magnifyingglass")
            items[1].image = UIImage(systemName: "doc.text.magnifyingglass")
            items[1].title = "Search"
            
            items[2].selectedImage = UIImage(systemName: "books.vertical")
            items[2].image = UIImage(systemName: "books.vertical")
            items[2].title = "Library"
        }
        
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.backgroundColor = .white
        tabBarAppearance.stackedLayoutAppearance.normal.iconColor = UIColor.ybgray
        tabBarAppearance.stackedLayoutAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.ybgray]
        tabBarAppearance.stackedLayoutAppearance.selected.iconColor = UIColor.ybyellow
        tabBarAppearance.stackedLayoutAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.ybyellow]
        UITabBar.appearance().standardAppearance = tabBarAppearance
        
        //탭 바가 스크롤 가능한 경우에 나타나는 외관을 설정
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        }
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground() // 반투명한 그림자를 백그라운드 앞에다 생성 (반투명한 그림자를 한겹을 쌓는다)
//        appearance.configureWithOpaqueBackground() // 불투명한 색상의 백그라운드 생성 (불투명한 그림자를 한겹을 쌓는다)
//        appearance.configureWithTransparentBackground() // 그림자 제거하고 기존의 백그라운드 색상을 사용 (그림자를 제거하고 기존 배경색을 사용)
                                                        // 👉 참고로 그림자를 제거하면 네비게이션 바 아래의 선을 제거할 수 있다.
       
        UINavigationBar.appearance().standardAppearance = appearance // 기본 내비게이션 바 (위로 스크롤 할 때 백그라운드 그림자 생성)
        
        
        
        window?.rootViewController = tabBarController
//        window?.rootViewController = DetailViewController()
        window?.makeKeyAndVisible()
        
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }


}

