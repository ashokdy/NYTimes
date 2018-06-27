//
//  ViewController.swift
//  NYTimes
//
//  Created by Ashok Devangam Yerra on 6/25/18.
//  Copyright © 2018 Ashok Devangam Yerra. All rights reserved.
//

import UIKit
import ZVProgressHUD

// MARK: - View Cycle
class ViewController: BaseViewController {
    
    @IBOutlet weak var articleTableView: UITableView?
    
    var viewModel = ArticleViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableViewAndViewModel()
    }
    
    override func updateUserInterface(_ status: NetworkStatus) {
        super.updateUserInterface(status)
        
        if status == .notReachable {
            Utils.showAlertView(title: "Alert!", message: "Please check your internet connection", handler: nil)
            ZVProgressHUD.dismiss()
        } else {
            //Load the Viewmodel again only if articles are not loaded before
            if viewModel.articles.count == 0 {
                viewModel.getArticlesFromNYTimes()
                loadViewModelAndHandlers()
            } else {
                //Just reload if already Articles are loaded
                self.articleTableView?.reloadData()
            }
        }
    }
    
    //Configure TableView and ViewModel
    func configureTableViewAndViewModel() {
        //Register Cell
        articleTableView?.register(ArticleMasterCell.nib, forCellReuseIdentifier: ArticleMasterCell.identifier)
        //Here our Hero comes - Assign ViewModel as Delegate and DataSource
        articleTableView?.dataSource = viewModel as UITableViewDataSource
        articleTableView?.delegate = viewModel as UITableViewDelegate
    }
    
    func loadViewModelAndHandlers() {
        
        ZVProgressHUD.maskType = .black
        ZVProgressHUD.show()
        
        //View Model completion block to reload the tableview once data is parsed
        viewModel.competionBlock = { [weak self] (result, error) in
            DispatchQueue.main.async {
                self?.articleTableView?.reloadData()
                ZVProgressHUD.dismiss()
            }
        }
        
        //View Model completion block to Handle selected action of the Article from ViewModel
        //Move to Details screen once called
        viewModel.articleDidSelect = { [weak self] (article, index) in
            self?.performSegue(withIdentifier: Identifiers.articleDetail, sender: article)
        }
    }
}

// MARK: - Navigation
extension ViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailViewController = segue.destination as? ArticleDetailViewController, let article = sender as? Article {
            detailViewController.article = article
        }
    }
}
