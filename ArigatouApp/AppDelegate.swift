//
//  AppDelegate.swift
//  ArigatouApp
//
//  Created by pero on 2024/04/12.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //iOS 15でNavigationBarがデフォルトで透過されるためのios14までと同じように表示する設定
        if #available(iOS 15.0, *) {
            //ナビゲーションバーの外観設定を宣言
            let navigationBarAppearance = UINavigationBarAppearance()
            //デフォルトの背景色を設定
            //navigationBarAppearance.configureWithDefaultBackground()
            navigationBarAppearance.backgroundColor = .black
            //各モードに代入
            UINavigationBar.appearance().standardAppearance = navigationBarAppearance
            UINavigationBar.appearance().compactAppearance = navigationBarAppearance
            UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
            
            //ナビゲーションバーのタイトル文字の色変更
            navigationBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

