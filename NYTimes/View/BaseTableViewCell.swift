//
//  BaseTableViewCell.swift
//  NYTimes
//
//  Created by Ashok Devangam Yerra on 6/27/18.
//  Copyright © 2018 Ashok Devangam Yerra. All rights reserved.
//

import UIKit

class BaseTableViewCell: UITableViewCell {
    
    //To get the UINib
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    //To get the identifer name same as Cell name
    static var identifier: String {
        return String(describing: self)
    }
}
