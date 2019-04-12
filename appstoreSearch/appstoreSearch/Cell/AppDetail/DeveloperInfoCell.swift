//
//  DeveloperInfoCell.swift
//  appstoreSearch
//
//  Created by Elon on 21/03/2019.
//  Copyright © 2019 Elon. All rights reserved.
//

import UIKit


final class DeveloperInfoCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var showMoreImageView: UIImageView!
    
    static let identifier = "DeveloperInfoCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initUI()
    }
}

extension DeveloperInfoCell {
    
    private func initUI() {
        titleLabel.text = ""
        subTitleLabel.text = ""
        showMoreImageView.image = UIImage(named: "rightArrow")
    }
    
    private func setTitle(text: String) {
        titleLabel.text = text
    }
    
    private func setSubTitle(text: String) {
        subTitleLabel.text = text
    }
    
    func setUI(with model: Info) {
        setTitle(text: model.title)
        setSubTitle(text: model.subTitle)
    }
}
