//
//  IntExtensions.swift
//  appstoreSearch
//
//  Created by Elon on 19/03/2019.
//  Copyright © 2019 Elon. All rights reserved.
//

import Foundation

extension Int {
    /**
     숫자에 콤마 추가 메소드
     
     - returns: (string) 콤마 추가된 숫자 문자열
     */
    func withCommas() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value: self)) ?? ""
    }
}
