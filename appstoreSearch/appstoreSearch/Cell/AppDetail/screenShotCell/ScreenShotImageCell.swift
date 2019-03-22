//
//  ScreenShotImageCell.swift
//  appstoreSearch
//
//  Created by Elon on 21/03/2019.
//  Copyright © 2019 Elon. All rights reserved.
//

import UIKit
import RxSwift

extension ScreenShotImageCell {
    
    func setImage(by urlString: String) {
        screenShot
            .rx_setImage(by: urlString)
            .disposed(by: disposeBag)
    }
}

class ScreenShotImageCell: UICollectionViewCell {
    
    @IBOutlet weak var screenShot: UIImageView!
    
    let disposeBag = DisposeBag()
    static let identifier = "ScreenShotImageCell"
    
    override func awakeFromNib() {
        screenShot.image = nil
    }
}
