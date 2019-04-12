//
//  AppDescriptionCell.swift
//  appstoreSearch
//
//  Created by Elon on 21/03/2019.
//  Copyright © 2019 Elon. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


final class AppDescriptionCell: UITableViewCell {

    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var readMoreButton: UIButton!
    
    private let disposeBag = DisposeBag()
    static let identifier = "AppDescriptionCell"
    var needExtened: Bool = false
    var readMore: (Bool) -> Void = {_ in }
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
}

extension AppDescriptionCell {
    
    private func initUI() {
        descriptionLabel.text = ""
        descriptionLabel.numberOfLines = 3
        readMoreButton.isHidden = true
    }
    
    private func setDescription(by text: String) {
        let count = text.components(separatedBy: "\n").count
        
        if needExtened {
            readMoreButton.isHidden = true
        } else if count > 3 {
            readMoreButton.isHidden = false
        }
        
        descriptionLabel.extendable(text: text,
                                    extened: needExtened,
                                    lineHeightMultiple: true)
    }
    
    private func tapReadMore() {
        readMoreButton
            .rx.tap
            .asDriver()
            .drive(onNext: { [unowned self] in
                self.readMore(true)
            })
            .disposed(by: disposeBag)
    }
    
    func setUI(with model: Description) {
        self.needExtened = model.needExtened
        setDescription(by: model.text)
        tapReadMore()
    }
}
