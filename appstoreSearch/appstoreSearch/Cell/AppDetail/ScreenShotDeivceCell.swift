//
//  ScreenShotDeivceCell.swift
//  appstoreSearch
//
//  Created by Elon on 21/03/2019.
//  Copyright © 2019 Elon. All rights reserved.
//

import UIKit


extension ScreenShotDeivceCell {
    
    func initUI() {
        deviceIconImageView.image = nil
        titleLabel.text = ""
        showMoreImageView.image = nil
    }
    
    func setDeviveIcon(by image: UIImage?) {
        deviceIconImageView.image = image
    }
    
    func setTitle(text: String) {
        titleLabel.text = text
    }
    
    func setShowMore(by model: DeviceInfo) {
        guard model.screenShots.count > 0 else { return }
        //TODO: 아이패드 스크린샷 보기 구현
        //showMoreImageView.image = UIImage(named: "bottomArrow")
        showMoreImageView.isHidden = true
    }
    
    func setUI(with model: DeviceInfo) {
        self.needExtened = model.needExtened
        setDeviveIcon(by: model.icon)
        setTitle(text: model.title)
        setShowMore(by: model)
    }
}

class ScreenShotDeivceCell: UITableViewCell {

    @IBOutlet weak var deviceIconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var showMoreImageView: UIImageView!
    
    static let identifier = "ScreenShotDeivceCell"
    var needExtened: Bool = false
    var readMore: (Bool) -> Void = {_ in }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initUI()
    }
}
