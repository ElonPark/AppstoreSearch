//
//  AppInfoTitleCell.swift
//  appstoreSearch
//
//  Created by Elon on 21/03/2019.
//  Copyright © 2019 Elon. All rights reserved.
//

import UIKit


final class AppInfoTitleCell: UITableViewCell {
    
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    static let identifier = "AppInfoTitleCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.text = ""
    }
}

extension AppInfoTitleCell {
    func setTitle(text: String) {
        titleLabel.text = text
    }
}
