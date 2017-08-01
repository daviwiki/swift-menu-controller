//
//  AppDelegate.swift
//  SwipeMenu
//
//  Created by David Martinez on 27/07/2017.
//  Copyright © 2017 atenea. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let swipe = storyboard.instantiateViewController(withIdentifier: "swipe") as! SwipeZoomMenuViewController
        let menu = storyboard.instantiateViewController(withIdentifier: "menu") as! MenuViewController
        let content = storyboard.instantiateViewController(withIdentifier: "content") as! ContentViewController
        content.setOutput(output: swipe)
        swipe.setContentController(vc: content)
        swipe.setMenuController(vc: menu)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.blue
        window?.makeKeyAndVisible()
        window?.rootViewController = swipe
        
        return true
    }

}

