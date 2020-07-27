//
//  AppDelegate.swift
//  Defender Mobile
//
//  Created by Anton Nikitin on 24.12.19.
//  Copyright © 2019 RestySpp. All rights reserved.
//

import BRIck
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    private var appComponent: ApplicationComponent!
    private var launchRouter: LaunchRouting?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.appComponent = AppComponent { appComponent in
            let window = UIWindow(frame: UIScreen.main.bounds)
            self.window = window

            let result = RootBuilder(dependency: appComponent).build()
            self.launchRouter = result
            self.launchRouter?.launch(in: window)
        }

        
        
        return true
    }
}
