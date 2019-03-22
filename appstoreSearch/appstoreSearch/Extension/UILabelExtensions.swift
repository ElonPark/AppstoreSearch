//
//  UILabelExtensions.swift
//  appstoreSearch
//
//  Created by Elon on 22/03/2019.
//  Copyright © 2019 Elon. All rights reserved.
//

import UIKit

extension UILabel {
    
    func extendable(text: String, extened: Bool, lineHeightMultiple: Bool = false) {
        
        
        let font = UIFont.systemFont(ofSize: 14, weight: .regular)
        
        var attributes: [NSAttributedString.Key : Any] = [
            .font : font,
            ]
        
        if extened {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineHeightMultiple = 1.5
            attributes[.paragraphStyle] = paragraphStyle
        }
        
        let attributedString = NSAttributedString(string: text,
                                                  attributes: attributes)
        if extened {
            let width = self.frame.width
            let size = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
            
            let rect = attributedString.boundingRect(with: size,
                                                     options: .usesLineFragmentOrigin,
                                                     context: nil)
            let lines = rect.height / (font.lineHeight * 1.5)
            self.numberOfLines = Int(lines)
            self.bounds = rect
        }
        
        self.attributedText = attributedString
    }
    
}
