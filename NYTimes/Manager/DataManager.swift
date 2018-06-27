//
//  DataManager.swift
//  NYTimes
//
//  Created by Ashok Devangam Yerra on 6/25/18.
//  Copyright © 2018 Ashok Devangam Yerra. All rights reserved.
//

import UIKit

typealias CompletionHandler = (_ result: [Any]?, _ error: Error?) -> Void
typealias ViewModelCompletionBlock = (_ result: ArticleViewModel?, _ error: Error?) -> Void
typealias ArticleDidSelect = (_ article: Article, _ index: Int) -> Void

private enum API {
    static let BASE_URL = "http://api.nytimes.com/"
    static let CONTENT_URL = "svc/mostpopular/v2/mostviewed/all-sections/"
    static let NYTIMES_API_KEY = "3f34a872362e4df29f242a5f7b8d5924"
}

enum ServiceType: String {
    case json = ".json?api-key="
    case xml = ".xml?api-key="
}

enum PossibleDays: Int {
    case one = 1
    case seven = 7
    case thirty = 30
}

struct Identifiers {
    static let articleDetail = "ArticleDetail"
}

//MARK: - DataManager
class DataManager: NSObject {
    
    /// Load Newyork Times Most Viewed Articles
    ///
    /// - Parameters:
    ///   - noOfDays: PossibleDays - possible value {1, 7, 30}
    ///   - serviceType: ServiceType - possible value {json, xml}
    ///   - completionHandler: Handler to return the data, response and error
    class func getNYTimesArticles(_ noOfDays: PossibleDays = .seven, serviceType: ServiceType = .json, completionHandler: @escaping CompletionHandler) {
        
        //Make URL based on the given params and BASE URL along with API KEY
        let urlString = String(format: "%@%@%d%@%@", API.BASE_URL, API.CONTENT_URL, noOfDays.rawValue, serviceType.rawValue, API.NYTIMES_API_KEY)
        
        guard let url = URL(string: urlString) else { return }
        
        //Call service using session
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            do {
                //Decoder to parse the Articles
                let decoder = JSONDecoder()
                let articleResult = try decoder.decode(Articles.self, from: data)
                completionHandler(articleResult.articles, nil)
            } catch let error {
                completionHandler(nil, error)
            }
            }.resume()
    }
}
