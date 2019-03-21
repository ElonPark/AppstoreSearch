//
//  AppInfoTitleCell.swift
//  appstoreSearch
//
//  Created by Elon on 21/03/2019.
//  Copyright © 2019 Elon. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension AppInfoTitleCell {
    func setTitle(text: String) {
        titleLabel.text = text
    }
}

class AppInfoTitleCell: UITableViewCell {
    
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    let disposeBag = DisposeBag()
    static let identifier = "AppInfoTitleCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.text = ""
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
