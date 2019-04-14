//
//  ScreenShotImageCell.swift
//  appstoreSearch
//
//  Created by Elon on 21/03/2019.
//  Copyright © 2019 Elon. All rights reserved.
//

import UIKit

final class ScreenShotImageCell: UICollectionViewCell {
    
    @IBOutlet weak var screenShot: UIImageView!
    
    static let identifier = "ScreenShotImageCell"
    
    override func awakeFromNib() {
        screenShot.image = nil
    }
}

extension ScreenShotImageCell {
    func setScreenshot(image: UIImage?) {
        screenShot.image = image
    }
}
