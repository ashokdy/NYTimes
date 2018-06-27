//
//  ArticleDetailViewController.swift
//  NYTimes
//
//  Created by Ashok Devangam Yerra on 6/26/18.
//  Copyright © 2018 Ashok Devangam Yerra. All rights reserved.
//

import UIKit
import WebKit
import ZVProgressHUD

//MARK: - View Cycle
class ArticleDetailViewController: BaseViewController {
    
    @IBOutlet weak var articleDetailWebview: WKWebView?
    
    var article: Article?
    //Holds the Webview status - to check whether reload is needed or not once the internet is back
    var isWebViewLoaded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Confirms to NaviagationDelegate
        articleDetailWebview?.navigationDelegate = self
    }
    
    //Load Article details in Webview
    func loadArticleDetails() {
        ZVProgressHUD.maskType = .black
        ZVProgressHUD.show()
        if let url = URL(string: article?.urlString ?? "") {
            articleDetailWebview?.load(URLRequest(url: url))
            articleDetailWebview?.allowsBackForwardNavigationGestures = true
        }
    }
    
    override func updateUserInterface(_ status: NetworkStatus) {
        super.updateUserInterface(status)
        
        if status == .notReachable {
            Utils.showAlertView(title: "Alert!", message: "Please check your internet connection", handler: nil)
            ZVProgressHUD.dismiss()
        } else if !isWebViewLoaded { //As mentioned Load webview again only if not loaded before
            loadArticleDetails()
        }
    }
}

//MARK: - WKNavigationDelegate
extension ArticleDetailViewController: WKNavigationDelegate {
    
    //If loading commited stop HUD so that user can have scrollable UI
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        ZVProgressHUD.dismiss()
    }
    
    //If loading finished stop HUD if any in case and update isWebViewLoaded
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        ZVProgressHUD.dismiss()
        isWebViewLoaded = true
    }
    
    //If loading failed stop HUD
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        ZVProgressHUD.dismiss()
    }
}
