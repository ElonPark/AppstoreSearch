//
//  AppInfoCell.swift
//  appstoreSearch
//
//  Created by Elon on 21/03/2019.
//  Copyright © 2019 Elon. All rights reserved.
//

import UIKit


extension AppInfoCell {
    
    func initUI() {
        titleLabel.text = ""
        subTitleLabel.text = ""
        subTitleLabel.isHidden = false
        
        descriptionLabelConstraintBottom.constant = 0
        descriptionLabel.text = ""
        
        showMoreImageView.image = nil
        showMoreImageView.isHidden = true
        showMoreImageViewConstraintLeading.constant = 0
        showMoreImageViewConstraintWidth.constant = 0
    }
    
    func setTitleLabel(to text: String) {
        titleLabel.text = text
    }
    
    func setSubTitleLabel(to text: String) {
        if needExtened {
            subTitleLabel.isHidden = true
        } else {
            subTitleLabel.text = text
        }
    }
    
    func setShowMoreImage(by description: String) {
        guard !description.isEmpty else { return }
        guard !needExtened else { return }
        
        showMoreImageView.image = UIImage(named: "bottomArrow")
        showMoreImageView.isHidden = false
        showMoreImageViewConstraintLeading.constant = constraintLeading
        showMoreImageViewConstraintWidth.constant = showMoreImageViewWidth
    }
    
    func setDescriptionText(by text: String) {
        guard !text.isEmpty else { return }
        guard needExtened else { return }
        
        descriptionLabel.extendable(text: text, extened: needExtened)
        descriptionLabelConstraintBottom.constant = constraintBottom
    }
    
    func setUI(with model: Info) {
        self.needExtened = model.needExtened
        setTitleLabel(to: model.title)
        setSubTitleLabel(to: model.subTitle)
        setShowMoreImage(by: model.description)
        setDescriptionText(by: model.description)
    }
    
}


class AppInfoCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var showMoreImageViewConstraintLeading: NSLayoutConstraint!
    @IBOutlet weak var showMoreImageView: UIImageView!
    @IBOutlet weak var showMoreImageViewConstraintWidth: NSLayoutConstraint!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var descriptionLabelConstraintBottom: NSLayoutConstraint!
    
    @IBOutlet weak var lineView: UIView!
    
    static let identifier = "AppInfoCell"
    
    var needExtened: Bool = false
    
    let constraintLeading: CGFloat = 8
    let showMoreImageViewWidth: CGFloat = 20
    let constraintBottom: CGFloat = 10

    
    override func awakeFromNib() {
        super.awakeFromNib()
        initUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        initUI()
    }
}
