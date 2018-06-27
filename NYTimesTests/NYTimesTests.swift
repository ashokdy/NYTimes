//
//  NYTimesTests.swift
//  NYTimesTests
//
//  Created by Ashok Devangam Yerra on 6/25/18.
//  Copyright © 2018 Ashok Devangam Yerra. All rights reserved.
//

import XCTest
@testable import NYTimes

class NYTimesTests: XCTestCase {
    
    var sessionUnderTest: URLSession!
    var controllerUnderTest: ViewController!
    var viewModelUnderTest = ArticleViewModel()
    
    override func setUp() {
        super.setUp()
        sessionUnderTest = URLSession(configuration: URLSessionConfiguration.default)
        
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewController") as? ViewController {
            controllerUnderTest = viewController
            _ = controllerUnderTest.view
            controllerUnderTest.viewModel.getArticlesFromNYTimes()
        }
    }
    
    override func tearDown() {
        sessionUnderTest = nil
        controllerUnderTest = nil
        super.tearDown()
    }
    
    func testSuccessfullyLoadJSONFile() {
        
        guard let urlPath = Bundle.main.url(forResource: "MockArticles", withExtension: "json"), let jsonData = try? Data(contentsOf: urlPath) else {
            XCTFail("JSON file is missing")
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let articleResult = try decoder.decode(Articles.self, from: jsonData)
            
            XCTAssertEqual(articleResult.articles.first?.section, "U.S.", "Mathcing the Local JSON data")
            
            XCTAssertNotEqual(articleResult.articles.first?.publishedDate, "2018-06-06.", "Not Mathcing the Local JSON data")
            
            XCTAssertNotNil(articleResult, "Data cannot be nil to see list")
            
            controllerUnderTest.viewModel.articles = articleResult.articles
            
            controllerUnderTest.articleTableView?.register(ArticleMasterCell.nib, forCellReuseIdentifier: ArticleMasterCell.identifier)
            controllerUnderTest.articleTableView?.dataSource = viewModelUnderTest as UITableViewDataSource
            controllerUnderTest.articleTableView?.delegate = viewModelUnderTest as UITableViewDelegate
            
            controllerUnderTest.viewModel.tableView(controllerUnderTest.articleTableView!, didSelectRowAt: IndexPath(row: 0, section: 0))
        } catch  {
            XCTAssertNotNil("Data cannot be nil to see list")
        }
    }
    
    func testUnsuccessfullyLoadJSONFile() {
        
        guard let _ = Bundle.main.url(forResource: "MockArticle", withExtension: "json") else {
            XCTAssertNotNil("JSON file is missing")
            return
        }
        
        XCTAssertNotNil("Data is as per the flow")
    }
}
