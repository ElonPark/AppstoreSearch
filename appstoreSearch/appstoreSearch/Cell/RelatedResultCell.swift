//
//  RelatedResultCell.swift
//  appstoreSearch
//
//  Created by Elon on 18/03/2019.
//  Copyright © 2019 Elon. All rights reserved.
//

import UIKit


extension RelatedResultCell {
    
    func setTitle(text: String, with searchText: String) {
        let attributes: [NSAttributedString.Key : Any] = [
            .font: UIFont.systemFont(ofSize: 15),
            .foregroundColor: UIColor(white: 0.56, alpha: 1.0)
        ]
        
        let attributedString = NSMutableAttributedString(string: text,
                                                         attributes: attributes)
        
        
        if let range = text.range(of: searchText) {
            let nsRange = NSRange(range, in: text)
            attributedString.addAttribute(.foregroundColor,
                                          value: UIColor.black,
                                          range: nsRange)
        }
        
        titleLabel.attributedText = attributedString
    }
    
}

class RelatedResultCell: UITableViewCell {

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
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
