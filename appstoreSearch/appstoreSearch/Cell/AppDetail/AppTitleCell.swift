//
//  AppTitleCell.swift
//  appstoreSearch
//
//  Created by Elon on 20/03/2019.
//  Copyright © 2019 Elon. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension AppTitleCell {
    
    func setUI(with data: ResultElement) {
        appIconImageView
            .rx_setImage(by: data.artworkURL512)
            .disposed(by: disposeBag)
        
        titleLabel.text = data.trackName
        subTitleLabel.text = data.artistName
        
    }
}


class AppTitleCell: UITableViewCell {

    
    @IBOutlet weak var appIconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var downloadButton: UIButton!
    @IBOutlet weak var etcButton: UIButton!
    
    let disposeBag = DisposeBag()
    static let identifier = "AppTitleCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
