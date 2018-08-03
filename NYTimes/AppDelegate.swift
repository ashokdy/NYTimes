//
//  AppDelegate.swift
//  NYTimes
//
//  Created by Ashok Devangam Yerra on 6/25/18.
//  Copyright © 2018 Ashok Devangam Yerra. All rights reserved.
//

import UIKit

@UIApplicationMain

//MARK: - App Cycle
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        //hgfytf
        
        //Start monitoring for network status
        SSASwiftReachability.sharedManager?.startMonitoring()
        
        return true
    }
}
