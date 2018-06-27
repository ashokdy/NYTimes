//
//  DataManagerTests.swift
//  NYTimesTests
//
//  Created by Ashok Devangam Yerra on 6/27/18.
//  Copyright © 2018 Ashok Devangam Yerra. All rights reserved.
//

import XCTest
@testable import NYTimes

class DataManagerTests: XCTestCase {
    
    var sessionUnderTest: URLSession!
    
    override func setUp() {
        super.setUp()
        sessionUnderTest = URLSession(configuration: URLSessionConfiguration.default)
    }
    
    override func tearDown() {
        sessionUnderTest = nil
        super.tearDown()
    }
    
    func testSuccessfullGetArticleFromNYTimes() {
        DataManager.getNYTimesArticles(.seven) { (result, error) in
            guard error == nil else { return }
            XCTAssertNotNil(result, "Got Articles list from NYTimes")
        }
    }
    
    func testFailableGetArticleFromNYTimes() {
        DataManager.getNYTimesArticles(.thirty) { (result, error) in
            guard error != nil else { return }
            XCTAssertNil(result, "Failed getting Articles list from NYTimes")
        }
    }
    
    func testSuccessfullServiceCall() {
        // given
        let url = URL(string: "http://api.nytimes.com/svc/mostpopular/v2/mostviewed/all-sections/7.json?api-key=3f34a872362e4df29f242a5f7b8d5924")
        // 1
        let promise = expectation(description: "Status code: 200")
        
        // when
        let dataTask = sessionUnderTest.dataTask(with: url!) { data, response, error in
            // then
            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
                return
            } else if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if statusCode == 200 {
                    // 2
                    promise.fulfill()
                } else {
                    XCTFail("Status code: \(statusCode)")
                }
            }
        }
        dataTask.resume()
        // 3
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testFailableServiceCall() {
        // given
        let url = URL(string: "http://api.nytimes.com/svc/mostpopular/v2/mostviewed/all-sections/7.json?api-key=3f34a872362e4df29f242a5f7b8d59242")
        // 1
        let promise = expectation(description: "Completion handler invoked")
        var statusCode: Int?
        var responseError: Error?
        
        // when
        let dataTask = sessionUnderTest.dataTask(with: url!) { data, response, error in
            statusCode = (response as? HTTPURLResponse)?.statusCode
            responseError = error
            // 2
            promise.fulfill()
        }
        dataTask.resume()
        // 3
        waitForExpectations(timeout: 5, handler: nil)
        
        // then
        XCTAssertNil(responseError)
        XCTAssertEqual(statusCode, 403)
    }
}
