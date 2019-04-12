//
//  RelatedResultCell.swift
//  appstoreSearch
//
//  Created by Elon on 18/03/2019.
//  Copyright © 2019 Elon. All rights reserved.
//

import UIKit

final class RelatedResultCell: UITableViewCell {

    @IBOutlet weak var searchIconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var lineView: UIView!
    
    static let identifier = "RelatedResultCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.text = ""
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = ""
    }
}

extension RelatedResultCell {
    
    func setTitle(text: String, with searchText: String) {
        let whiteColor = UIColor(white: 0.56, alpha: 1.0)
        let attributedString = text.attribute(size: 14,
                                              weight: .regular,
                                              color: whiteColor)
        
        let nsString = NSString(string: text)
        let range = nsString.range(of: searchText)
        
        attributedString.addAttribute(.foregroundColor,
                                      value: UIColor.black,
                                      range: range)
        
        titleLabel.attributedText = attributedString
    }
    
}
