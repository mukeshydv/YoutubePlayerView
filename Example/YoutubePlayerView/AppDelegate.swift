//
//  AppDelegate.swift
//  YoutubePlayerView
//
//  Created by mukeshydv on 12/17/2018.
//  Copyright (c) 2018 mukeshydv. All rights reserved.
//

import UIKit
import AVKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        if let presentedController = window?.rootViewController?.presentedViewController {
            let className = String(describing: type(of: presentedController)).components(separatedBy: ".").last!
            if className == "MPMoviePlayerViewController" || className == "MPInlineVideoFullscreenViewController" || className == "AVFullScreenViewController" {
                return .allButUpsideDown
            }
        }

        return .portrait
    }
}

