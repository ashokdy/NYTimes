//
//  Constants.swift
//  NYTimes
//
//  Created by Ashok Devangam Yerra on 6/25/18.
//  Copyright © 2018 Ashok Devangam Yerra. All rights reserved.
//

import UIKit

extension UIImageView {
    
    func downloadImageAt(_ path: String?, withContentMode mode: UIViewContentMode = .scaleAspectFit) {
        
        guard let urlPath = path, let url = URL(string: urlPath) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            //Update images Asyn when the data is received
            DispatchQueue.main.async {
                self.contentMode =  mode
                if let data = data {
                    self.image = UIImage(data: data)
                }
            }
            }.resume()
    }
}

struct Utils {
    /// Returns application delegate
    static var applicationDelegate: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    /// Returns application keywindow
    static var applicationKeyWindow: UIWindow {
        return UIApplication.shared.keyWindow!
    }
    
    /// Switches to view controller specified
    ///
    /// - Parameters:
    ///   - viewController: View Controller to switch
    ///   - animationOption: Switching animaion type
    ///   - duration: Duration of switching animation
    static func switchToViewController(viewController: UIViewController, animationOption: UIViewAnimationOptions = .transitionCrossDissolve, duration: TimeInterval = 0.5, completion: (() -> ())? = nil) {
        DispatchQueue.main.async {
            UIView.transition(with: applicationKeyWindow, duration: duration, options: animationOption, animations: {
                applicationKeyWindow.rootViewController = viewController
            }, completion: { (_ finished: Bool) in
                completion?()
            })
        }
    }
    
    /// Checks for right to left interface
    ///
    /// - Returns: Return true if the interface is right to left
    static func isRightToLeftInterface() -> Bool {
        if UIView.appearance().semanticContentAttribute == .forceRightToLeft {
            return true
        }
        return false
    }
    
    /// Shows alert view
    ///
    /// - Parameters:
    ///   - title: Title for alert
    ///   - message: Message for alert
    ///   - handler: Code to execute on tapping OK
    static func showAlertView(title: String? = nil, message: String?, handler: ((UIAlertAction?) -> Void)?) {
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: handler)
        showAlertView(title: title, message: message, actions: [okAction])
    }
    /// Shows alert view
    ///
    /// - Parameters:
    ///   - title: Title for alert
    ///   - message: Message for alert
    ///   - completionHandler: Code to execute on tapping yes
    
    static func showAlertViewWithCompletion(title: String? = nil, message: String?, completionHandler: ((UIAlertAction?) -> Void)?) {
        let noAction = UIAlertAction(title: "No", style: .default, handler: nil)
        let yesAction = UIAlertAction(title: "Yes", style: .default, handler: completionHandler)
        
        showAlertView(title: title, message: message, actions: [noAction,yesAction])
    }
    /// Shows alert view
    ///
    /// - Parameters:
    ///   - title: Title for alert
    ///   - message: Message for alert
    ///   - actions: Actions for alert, e.g., ok, cancel.. buttons
    static func showAlertView(title: String? = nil, message: String?, actions: [UIAlertAction]) {
        if let _ = applicationKeyWindow.rootViewController?.presentedViewController as? UIAlertController { return }
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        /// TODO: Get tint from themes
        //        alertController.view.tintColor = UIColor.gpButterscotchColor()
        
        for action in actions {
            alertController.addAction(action)
        }
        
        if let presentedVC = applicationKeyWindow.rootViewController?.presentedViewController {
            presentedVC.present(alertController, animated: true, completion: nil)
        }
        else {
            applicationKeyWindow.rootViewController?.present(alertController, animated: true, completion: nil)
        }
    }
}
