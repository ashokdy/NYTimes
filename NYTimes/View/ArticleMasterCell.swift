//
//  ArticleMasterCell.swift
//  NYTimes
//
//  Created by Ashok Devangam Yerra on 6/25/18.
//  Copyright © 2018 Ashok Devangam Yerra. All rights reserved.
//

import UIKit

class ArticleMasterCell: BaseTableViewCell {
    
    @IBOutlet weak var thumbNailIcon: UIImageView?
    @IBOutlet weak var articleTitleLabel: UILabel?
    @IBOutlet weak var lineByLabel: UILabel?
    @IBOutlet weak var typeLabel: UILabel?
    @IBOutlet weak var publishedDateLabel: UILabel?
    
    //When the Article is assigned then the Cell UI will be configured
    var article: Article? {
        didSet {
            configureCell()
        }
    }
    
    func configureCell() {
        //Check if article has value
        guard let article = article else { return }
        //Download the Image from URL - async
        self.thumbNailIcon?.downloadImageAt(article.mediaImages?.first?.imagesDetails?.first?.url)
        self.articleTitleLabel?.text = article.title
        self.lineByLabel?.text = article.byLine
        self.typeLabel?.text = article.section
        self.publishedDateLabel?.text = article.publishedDate
        
        self.thumbNailIcon?.layer.cornerRadius = (thumbNailIcon?.frame.size.width ?? 0)/2
    }
}
