//
//  BaseViewController.swift
//  NYTimes
//
//  Created by Ashok Devangam Yerra on 6/27/18.
//  Copyright © 2018 Ashok Devangam Yerra. All rights reserved.
//

import UIKit

// MARK: - View Cycle
class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Start Monitoring the Network service
        SSASwiftReachability.sharedManager?.startMonitoring()
        
        // MARK: Listen For Network Reachability Changes
        NotificationCenter.default.addObserver(self, selector: #selector(self.reachabilityStatusChanged(notification:)), name: NSNotification.Name(rawValue: SSAReachabilityDidChangeNotification), object: nil)
    }
    
    @objc func reachabilityStatusChanged(notification: NSNotification) {
        if let info = notification.userInfo {
            if let status = info[SSAReachabilityNotificationStatusItem] {
                if ((status as AnyObject).description) == "reachable" {
                    updateUserInterface(.reachable)
                } else {
                    updateUserInterface(.notReachable)
                }
            }
        }
    }
    
    func updateUserInterface(_ status: NetworkStatus) {
        //Overriden in sub classes
    }
}
