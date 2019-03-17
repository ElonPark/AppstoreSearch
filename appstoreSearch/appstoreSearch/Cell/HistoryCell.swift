//
//  HistoryCell.swift
//  appstoreSearch
//
//  Created by Elon on 17/03/2019.
//  Copyright © 2019 Elon. All rights reserved.
//

import UIKit

class HistoryCell: UITableViewCell {

    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    static let identifier = "HistoryCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.text = ""
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = ""
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        titleLabel.textColor = selected ? UIColor.white : tintColor
        contentView.backgroundColor = selected ? tintColor : UIColor.white
    }

}
